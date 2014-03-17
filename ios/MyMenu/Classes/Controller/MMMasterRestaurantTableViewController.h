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
#import <CoreLocation/CoreLocation.h>

#import "MMDBFetcherDelegate.h"
#import "MMDBFetcher.h"
#import "MMMerchant.h"
#import "MMLocationManager.h"

@class MMDetailMapViewController;

/**
 *  The identifier for the notification that is
 *  sent when a user begins searching for a
 *  a restaurant. When a subscriber receives
 *  this notification, it updates the restaurant
 *  list in the `MMMasterRestaurantTableViewController`
 */
extern NSString *const kDidUpdateList;

/**
 *  The Restaurant table shown on the Restaurants tab. (Next to the map)
 */
@interface MMMasterRestaurantTableViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 *  Array of Restaurants
 */
@property(nonatomic, strong) NSArray *restaurants;

/**
 *  Array of filtered Restaurants. IE. Searched items, By type ect...
 */
@property(nonatomic, strong) NSArray *filteredrestaurants;

/**
 *  User selected restaurant IE pressed
 */
@property(nonatomic, strong) MMMerchant *selectedRestaurant;

/**
 *  The map view controller to the right of the tableview
 */
@property(nonatomic, strong) MMDetailMapViewController *detailViewController;

/**
 *  The current DBFetcher
 */
@property(nonatomic, strong) MMDBFetcher *dbFetcher;

/**
 *  The current users location, if GPS is on
 */
@property(nonatomic) CLLocation *location;

/**
 *  Is the user searching?
 */
@property(nonatomic) BOOL searchflag;

/**
 *  The search bar that is displayed at the top of the tableview
 */
@property IBOutlet UISearchBar *merchantSearchBar;

/**
 *  Tab bar for filtering restaurants by, Cuisine, Location, and Rating
 */
@property IBOutlet UISegmentedControl *orderbySegmentControl;

/**
 *  The Tableview to put the data into.
 */
@property IBOutlet UITableView *tableView;

@end
