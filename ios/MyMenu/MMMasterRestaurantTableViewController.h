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
extern NSString *const kDidUpdateList;
@class MMDetailMapViewController;

@interface MMMasterRestaurantTableViewController : UIViewController <MMDBFetcherDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *restaurants;
@property(nonatomic, strong) NSArray *filteredrestaurants;
@property(nonatomic, strong) MMMerchant *selectRest;
@property(nonatomic, strong) MMDetailMapViewController *detailViewController;
@property(nonatomic, strong) MMDBFetcher *dbFetcher;
@property(nonatomic, strong) MMLocationManager *locationManager;
@property(nonatomic) CLLocation *location;
@property(nonatomic) BOOL searchflag;

@property IBOutlet UISearchBar *merchantsearch;
@property IBOutlet UISegmentedControl *orderbySegmentControl;
@property IBOutlet UITableView *tableView;

@end