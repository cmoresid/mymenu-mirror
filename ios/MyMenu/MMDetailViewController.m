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

#import "MMDetailViewController.h"
#import "MMMerchant.h"
#import "MMDBFetcher.h"

@interface MMDetailViewController ()
@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation MMDetailViewController

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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];

    // Set up the map bounds
    // TODO: use the user's location
    MKCoordinateSpan span;
    span.latitudeDelta = .5;
    span.longitudeDelta = .5;
    CLLocationCoordinate2D start;
    start.latitude = 53.53333;
    start.longitude = -113.5000;
    MKCoordinateRegion region;
    region.center = start; //= self.mapView.userLocation.coordinate.longitude;
    //region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.span = span;

    // Add pins for the restaurants
    [self pinRestaurants];

    [self.mapView setRegion:region animated:YES];
}

- (void)pinRestaurants {
    MMDBFetcher *fetcher = [MMDBFetcher get];
    NSArray *restaurants = [fetcher getCompressedMerchants];

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
