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

#import "RVMViewModel.h"

/**
 *  Constant that corresponds the order by 
 *  recent segmented tab that is created inside
 *  `RestaurantViewController`.
 */
extern const NSInteger MMOrderByRecent;

/**
 *  Constant that corresponds the order by
 *  top rated segmented tab that is created inside
 *  `RestaurantViewController`.
 */
extern const NSInteger MMOrderByTopRated;

/**
 *  Indicates that the view model's data source
 *  contains `MMMenuItem` objects. `RestaurantViewController`
 *  uses this constant know which collection
 *  cells to configure.
 */
extern const NSInteger MMMenuItemDataSource;

/**
 *  Indicates that the view model's data source
 *  contains `MMMenuItemRating` objects. `RestaurantViewController`
 *  uses this constant know which collection
 *  cells to configure.
 */
extern const NSInteger MMReviewsDataSource;

@class MMMerchant;
@class RACSubject;

/**
 *  The View Model for `MMRestaurantViewController`. Responsible
 *  for providing the data for the view controller. 
 *
 *  See `anlax.com/blog/model-view-viewmodel-for-ios/` for more
 *  information on the ModelView-View-Model (MVVM) architecture
 *  pattern.
 */
@interface MMRestaurantViewModel : RVMViewModel

/**
 *  The `MMMerchant` model that this view model represents.
 */
@property(nonatomic, strong) MMMerchant *merchantInformation;

/**
 *  Notifies the corresponding controller to hide/show a progress
 *  indicator based on whether or not data is currently being
 *  retrieved from the network.
 */
@property(nonatomic, strong) RACSubject *controllerShouldShowProgressIndicator;

/**
 *  Notifies the corresponding conroller that the data source
 *  has been updated.
 */
@property(nonatomic, strong) RACSubject *controllerShouldReloadDataSource;

/**
 *  Represents the currently selected tab in the
 *  view.
 */
@property(nonatomic) NSInteger selectedTabIndex;

/**
 *  Represents which orderering the reviews
 *  should be organized by.
 *
 *  @see `MMOrderByRecent` and `MMOrderByTopRated`
 */
@property(nonatomic) NSInteger reviewOrder;

/**
 *  Represents the type of objects that are
 *  currently in the data source.
 *
 *  @see `MMMenuItemDataSource` and `MMReviewsDataSource`
 */
@property(nonatomic) NSInteger dataSourceType;

/**
 *  Represents the index that corresponds to the
 *  review tab. This evaluates to the number of
 *  categories a restaurant has + 1.
 */
@property(nonatomic, readonly, getter = getReviewTabIndex) NSNumber *reviewTabIndex;

/**
 *  Retrieves an `NSArray` of strings that will
 *  represent the tab names in the category
 *  segmented control.
 *
 *  @return A signal containing an `NSArray` of
 *          category names.
 */
- (RACSignal *)getTabCategories;

/**
 *  Retrieves an `NSMutableArray` of all
 *  the menu items for the currently
 *  represented restaurant.
 *
 *  @return A `NSMutableArray` of all the
 *          menu items for the current
 *          merchant.
 */
- (RACSignal *)getAllMenuItems;

/**
 *  Returns the number of items in the
 *  data source.
 *
 *  @return The number of items in the
 *          current data source.
 */
- (NSInteger)numberOfItemsInCurrentDataSource;

/**
 *  Returns the object that at the specified
 *  index in the current data source.
 *
 *  @param indexPath Position of object in data source.
 *
 *  @return The object at the specified position in data
 *          source.
 */
- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath;

/**
 *  Searchs for a value in the current data sources and
 *  updates public data source to reflect the values
 *  found. Currently, this method only works when the
 *  data source has `MMMenuItem` object in it. The
 *  search is performed against the `name` property
 *  of the `MenuItem`.
 *
 *  @param valueToSearchFor The value of the `name` to search
 *                          for.
 */
- (void)searchForItemWithValue:(NSString *)valueToSearchFor;

@end
