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
#import "MMMerchantService.h"

NSString *const kDidUpdateList = @"DidUpdateList";

@interface MMDetailMapViewController ()

@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) UIPopoverController *masterPopoverController;
@property(strong, nonatomic) id <MKMapViewDelegate> mapDelegate;

- (void)configureView;

@end

@implementation MMDetailMapViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
     @weakify(self);
    [[[[MMLocationManager sharedLocationManager].getLatestLocation
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(CLLocation *location) {
            @strongify(self);
            self.location = location;
            [self didReceiveUserLocation:location];
            
            return [[MMMerchantService sharedService] getDefaultCompressedMerchantsForLocation:location];
        }]
        subscribeNext:^(NSMutableArray *merchants) {
            @strongify(self);
            [self didUpdateList:merchants];
        }
        error:^(NSError *error) {
            NSLog(@"error");
    }];
    
    // Don't allow the map to track the user's location...
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Manage Detail View (Portrait Mode)

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView]; // Update the view
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

#pragma mark - Location Notification Callback Methods

- (void)didUpdateList:(NSMutableArray *)merchants {
    NSMutableArray *annots = [_mapView.annotations mutableCopy];

    for (int i = 0; i < [annots count]; i++) {
        if (![[annots objectAtIndex:i] isKindOfClass:[MKUserLocation class]])
            [annots removeObjectAtIndex:i];
    }

    [_mapView removeAnnotations:[annots copy]];
    [self pinRestaurants:[merchants copy]];

}

- (void)didReceiveUserLocation:(CLLocation *)location {
    MKCoordinateSpan span;
    span.latitudeDelta = .25;
    span.longitudeDelta = .25;

    MKCoordinateRegion region;
    region.center = location.coordinate;
    region.span = span;

    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    [self.mapView setRegion:region animated:NO];

    self.mapDelegate = [[MMRestaurantMapDelegate alloc] init];
    self.mapView.delegate = self.mapDelegate;
}

#pragma mark - Configure Map View Methods

- (void)pinRestaurants:(NSArray *)restaurants {
    if ([restaurants count] == 1) {
        [self configureMapForOneRestaurant:restaurants];
    }
    else {
        [self configureMapForManyRestaurants];
    }

    for (int i = 0; i < restaurants.count; i++) {
        [self addPinForRestaurantToMap:[restaurants objectAtIndex:i]];
    }
}

- (void)addPinForRestaurantToMap:(MMMerchant *)restaurant {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D start;
    start.latitude = [restaurant.lat doubleValue];
    start.longitude = [restaurant.longa doubleValue];
    [annotation setCoordinate:start];
    [annotation setTitle:restaurant.businessname];
    [annotation setSubtitle:restaurant.desc];

    [self.mapView addAnnotation:annotation];
}

- (void)configureMapForManyRestaurants {
    MKCoordinateSpan span;
    span.latitudeDelta = .25;
    span.longitudeDelta = .25;

    MKCoordinateRegion region;
    region.center = self.location.coordinate;
    region.span = span;

    [self.mapView setCenterCoordinate:self.location.coordinate animated:YES];
    [self.mapView setRegion:region animated:YES];
}

- (void)configureMapForOneRestaurant:(NSArray *)restaurants {
    MKCoordinateSpan span;
    span.latitudeDelta = .25;
    span.longitudeDelta = .25;

    MMMerchant *merch = [restaurants objectAtIndex:0];

    MKCoordinateRegion region;
    CLLocationCoordinate2D start;
    start.latitude = [merch.lat doubleValue];
    start.longitude = [merch.longa doubleValue];
    region.center = start;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}

#pragma mark - RBStoryboardLinkSource Delegate Methods

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (BOOL)needsBottomLayoutGuide {
    return FALSE;
}

#pragma mark - MMDBFetcher Delegate Methods

- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile Creation Error", nil)
                                                          message:NSLocalizedString(@"Unable to create user profile.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [message show];

        return;
    }
}

- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dietary Restriction Error", nil)
                                                          message:NSLocalizedString(@"Unable to update dietary restrictions.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [message show];

        return;
    }
}

#pragma mark - Split View Delegate Methods

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"List", @"List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
