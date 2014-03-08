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

NSString *const kDidUpdateList = @"DidUpdateList";

@interface MMDetailMapViewController ()

@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) UIPopoverController *masterPopoverController;
@property(strong, nonatomic) id <MKMapViewDelegate> mapDelegate;

- (void)configureView;

@end

@implementation MMDetailMapViewController

#pragma mark - Managing the detail item
#pragma TODO: Setup map to point to user location
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView]; // Update the view
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (BOOL)needsBottomLayoutGuide {
    return FALSE;
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void) didUpdateList :(NSNotification *)notification {
    
    NSMutableArray *annots = [_mapView.annotations mutableCopy];
    
    for(int i = 0;i<[annots count];i++){
        if([[annots objectAtIndex:i] isKindOfClass: [MKUserLocation class]])
                [annots removeObjectAtIndex:i];
    }
    
    [_mapView removeAnnotations:[annots copy]];
    
    [self pinRestaurants:notification.object];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /* Observer watching for a user location update notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUserLocation:)
                                                 name:kRetrievedUserLocation
                                               object:nil];
   
    
    /* Obeserver watching for the master list to be updated */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateList:)
                                                 name:kDidUpdateList
                                               object:nil];
}

- (void)didReceiveUserLocation:(NSNotification *)notification {
    _location = notification.object;
    
    MKCoordinateSpan span;
    span.latitudeDelta = .25;
    span.longitudeDelta = .25;
    
    MKCoordinateRegion region;
    region.center = _location.coordinate;
    region.span = span;
    
    [self.mapView setCenterCoordinate:_location.coordinate animated:YES];
    [self.mapView setRegion:region animated:YES];
    self.mapDelegate = [[MMRestaurantMapDelegate alloc] init];
    self.mapView.delegate = self.mapDelegate;

 
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Profile Creation Error"
                                                          message:@"Unable to create user profile."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }
}

- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Dietary Restriction Error"
                                                          message:@"Unable to update dietary restrictions."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }
}

// Actually put all the pins on the map for each restaurant
- (void)pinRestaurants:(NSArray *)restaurants {
    
    if([restaurants count] == 1) {
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
    else {
        MKCoordinateSpan span;
        span.latitudeDelta = .25;
        span.longitudeDelta = .25;

        MKCoordinateRegion region;
        region.center = _location.coordinate;
        region.span = span;
    
        [self.mapView setCenterCoordinate:_location.coordinate animated:YES];
        [self.mapView setRegion:region animated:YES];
    }
    
    for (int i = 0; i < restaurants.count; i++) {
        MMMerchant *restaurant = [restaurants objectAtIndex:i];

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D start;
        start.latitude = [restaurant.lat doubleValue];
        start.longitude = [restaurant.longa doubleValue];
        [annotation setCoordinate:start];
        [annotation setTitle:restaurant.businessname];
        [annotation setSubtitle:restaurant.desc];

        [self.mapView addAnnotation:annotation];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

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
