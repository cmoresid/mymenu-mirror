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

@implementation MMRestaurantMapDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *AnnotationViewID = @"annotationViewID";
    
    NSString *annotationId;
    NSString *imageName;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else {
        annotationId = AnnotationViewID;
        imageName = @"location-marker.png";
    }
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [map dequeueReusableAnnotationViewWithIdentifier:annotationId];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
    }
    
    
    annotationView.image = [UIImage imageNamed:imageName];
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    for (MKAnnotationView *annView in annotationViews) {
        if ([annView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             annView.frame = endFrame;
                         }];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[MKUserLocation class]]){
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
