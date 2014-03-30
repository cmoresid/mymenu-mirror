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

#import "MMDetailMapViewController.h"
#import "MMLocationManager.h"
#import "MMRestaurantMapDelegate.h"
#import "MMMasterRestaurantTableViewController.h"
#import "MMAppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <CCHMapClusterController/CCHMapClusterController.h>
#import "MMMerchantService.h"
#import "MMSplitViewController.h"

@interface MMDetailMapViewController ()

@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) id <MKMapViewDelegate> mapDelegate;
@property(strong, nonatomic) CCHMapClusterController *mapClusterController;

@end

@implementation MMDetailMapViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[MMLocationManager sharedLocationManager].getLatestLocation
        subscribeNext:^(CLLocation *location) {
            @strongify(self);
            self.location = location;
            [self didReceiveUserLocation:location];
        }
        error:^(NSError *error) {
            NSLog(@"MMDetailMapViewController.viewDidLoad - Error retrieving location.");
    }];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    
    MMRestaurantMapDelegate *delegate = [[MMRestaurantMapDelegate alloc] init];
    delegate.splitViewNavigationController = [self.splitViewController.viewControllers lastObject];
    delegate.mapView = self.mapView;
    
    self.mapDelegate = delegate;
    self.mapView.delegate = self.mapDelegate;
    
    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    self.mapClusterController.delegate = delegate;
}

- (void)didReceiveMerchants:(NSMutableArray *)merchants {
    NSArray *annots = [self.mapClusterController.annotations copy];
    
    RACSequence *annotsSequence = [annots.rac_sequence
        filter:^BOOL(MKPointAnnotation *annot) {
            return ![annot isKindOfClass:[MKUserLocation class]];
    }];
    
    [self.mapClusterController removeAnnotations:annotsSequence.array withCompletionHandler:^{
        [self pinRestaurants:[merchants copy]];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Notification Callback Methods

- (void)didReceiveUserLocation:(CLLocation *)location {
    MKCoordinateSpan span;
    span.latitudeDelta = .25;
    span.longitudeDelta = .25;

    MKCoordinateRegion region;
    region.center = location.coordinate;
    region.span = span;

    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    [self.mapView setRegion:region animated:NO];
}

#pragma mark - Configure Map View Methods

- (void)pinRestaurants:(NSArray *)restaurants {
    RACSequence *mapAnnotations = [restaurants.rac_sequence
        map:^MKPointAnnotation*(MMMerchant *restaurant) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D start;
            start.latitude = [restaurant.lat doubleValue];
            start.longitude = [restaurant.longa doubleValue];
            annotation.coordinate = start;
            annotation.title = [restaurant.mid stringValue];
            annotation.subtitle = restaurant.businessname;
        
            return annotation;
    }];
    
    NSArray *mapAnnotationsArray = mapAnnotations.array;
    
    @weakify(self);
    [self.mapClusterController addAnnotations:mapAnnotationsArray withCompletionHandler:^{
        @strongify(self);
        [self zoomToFitCoordinates:mapAnnotationsArray];
    }];
}

- (void)zoomToFitCoordinates:(NSArray*)annotations {
    if ([annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - RBStoryboardLinkSource Delegate Methods

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (BOOL)needsBottomLayoutGuide {
    return FALSE;
}

#pragma mark - Split View Delegate Methods

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"View Restaurants", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
