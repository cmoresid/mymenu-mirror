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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MMDBFetcherDelegate.h"
#import "MMDBFetcher.h"
#import <RBStoryboardLink/RBStoryboardLinkSource.h>
#import "MMMerchantDataSourceDelegate.h"

@class MMLocationManager;
@class MMRestaurantMapDelegate;

/**
 *  Map View on the Restaruants tab.
 */
@interface MMDetailMapViewController : UIViewController <UISplitViewControllerDelegate, MMMerchantDataSourceDelegate, RBStoryboardLinkSource>

@property(nonatomic, strong) id detailItem;
@property(nonatomic, weak) IBOutlet UILabel *detailDescriptionLabel;

/**
 *  Current users location, based on GPS
 */
@property(nonatomic) CLLocation *location;

/**
 *  Adds the restaurants to the map view.
 *
 *  @param restaurants in an NSArray
 */
- (void)pinRestaurants:(NSArray *)restaurants;

@end