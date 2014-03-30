//
//  Copyright (C) 2014  MyMenu, Inc.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see [http://www.gnu.org/licenses/].
//

#import "MMRestaurantMapDelegate.h"
#import "MMMerchantService.h"
#import "MMMerchant.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MMPresentationFormatter.h"
#import <CCHMapClusterController/CCHMapClusterAnnotation.h>
#import "MMClusterAnnotationView.h"

@implementation MMRestaurantMapDelegate

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    
    NSUInteger numAnnotations = mapClusterAnnotation.annotations.count;
    NSString *unit = numAnnotations > 1 ? NSLocalizedString(@"restaurants", nil) : NSLocalizedString(@"restaurant", nil);
    return [NSString stringWithFormat:@"%tu %@", numAnnotations, unit];
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    
    NSUInteger numAnnotations = MIN(mapClusterAnnotation.annotations.count, 5);
    NSArray *annotations = [mapClusterAnnotation.annotations.allObjects subarrayWithRange:NSMakeRange(0, numAnnotations)];
    NSArray *titles = [annotations valueForKey:@"subtitle"];
    
    return [titles componentsJoinedByString:@", "];
}

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    
    MMClusterAnnotationView *clusterAnnotationView = (MMClusterAnnotationView *)[self.mapView viewForAnnotation:mapClusterAnnotation];
    clusterAnnotationView.count = mapClusterAnnotation.annotations.count;
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *identifier = @"clusterAnnotation";
    
    MMClusterAnnotationView *clusterAnnotationView = (MMClusterAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (clusterAnnotationView) {
        clusterAnnotationView.annotation = annotation;
    } else {
        clusterAnnotationView = [[MMClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        clusterAnnotationView.canShowCallout = YES;
    }
    
    CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
    clusterAnnotationView.count = clusterAnnotation.annotations.count;
    
    return clusterAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    BOOL isUserLocationAnnotation = [view.annotation isKindOfClass:[MKUserLocation class]];
    BOOL isSingleAnnotation = ((MMClusterAnnotationView *)view).count == 1;
    
    if(isUserLocationAnnotation || !isSingleAnnotation) {
        return;
    }
    
    [mapView deselectAnnotation:view.annotation animated:YES];
    NSNumber *merchId = [NSNumber numberWithInteger:[((MKPointAnnotation *) view.annotation).title integerValue]];
    
    [[[MMMerchantService sharedService] getMerchantWithMerchantID:merchId]
     subscribeNext:^(MMMerchant *merchant) {
         
         [self createPopOverView:merchant];
         
         self.mapPopOverViewController = [[MMMapPopOverViewController alloc] init];
         [self.mapPopOverViewController setView:self.containerView];
         [self.mapPopOverViewController setPreferredContentSize:CGSizeMake(self.containerView.frame.size.width, 80)];
         
         self.mapPopOverViewController.merchant = merchant;
         self.mapPopOverViewController.contentView = self.containerView;
         self.mapPopOverViewController.splitViewNavigationController = self.splitViewNavigationController;
         
         self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.mapPopOverViewController];
         self.popOverController.delegate = self;
         self.mapPopOverViewController.popOverController = self.popOverController;
         
         [self.popOverController presentPopoverFromRect:view.frame
                                                 inView:view.superview
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
         
     }];
}

/**
 *  Fills the popover view with the information needed.
 */
-(void)createPopOverView:(MMMerchant *)merchant{
    UIImageView *merchImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    UILabel *merchTitle = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 250, 15)];
    UILabel *merchPhone = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 250, 15)];
    UILabel *merchHours = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 250, 15)];
    
    [merchImage setImageWithURL:[NSURL URLWithString:merchant.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    
    merchTitle.text = merchant.businessname;
    merchTitle.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]+3];
    [merchTitle sizeToFit];
    
    merchPhone.text = merchant.phone;
    [merchPhone sizeToFit];
    
    merchHours.text = [MMPresentationFormatter formatBusinessHoursForOpenTime:merchant.opentime withCloseTime:merchant.closetime];
    [merchHours sizeToFit];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(merchTitle.frame.size.width,merchPhone.frame.size.width) + 85, 80)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView addSubview:merchImage];
    [self.containerView addSubview:merchTitle];
    [self.containerView addSubview:merchPhone];
    [self.containerView addSubview:merchHours];
    
    self.containerView.userInteractionEnabled = YES;
}

@end
