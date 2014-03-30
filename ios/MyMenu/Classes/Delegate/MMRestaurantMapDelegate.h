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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>
#import "MMMapPopOverViewController.h"

/**
 * Implements the `MMMapViewDelegate` protocol provided by
 * Apple. We implement the delegate in order to provide
 * custom pins for the restaurants.
 */
@interface MMRestaurantMapDelegate : NSObject <MKMapViewDelegate, UIPopoverControllerDelegate, CCHMapClusterControllerDelegate>

/**
 *  Reference to the popover controller
 */
@property(nonatomic, strong) MMMapPopOverViewController *mapPopOverViewController;
/**
 *  Popover view controller
 */
@property(nonatomic, strong) UIPopoverController *popOverController;

/**
 *  Outlet to the popover view to detect touches.
 */
@property(nonatomic, strong) UIView * containerView;

/**
 *  reference to the navigation controller in the map view
 */
@property(nonatomic, strong) UINavigationController *splitViewNavigationController;

/**
 *  The map view that corresponds to the map view
 */
@property(nonatomic, weak) MKMapView *mapView;

@end
