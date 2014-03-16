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

extern const NSInteger MMOrderByRecent;
extern const NSInteger MMOrderByTopRated;
extern const NSInteger MMMenuItemDataSource;
extern const NSInteger MMReviewsDataSource;

@class MMMerchant;
@class RACSubject;

@interface MMRestaurantViewModel : RVMViewModel

@property(nonatomic, strong) MMMerchant *merchantInformation;
@property(nonatomic, strong) RACSubject *controllerShouldShowProgressIndicator;
@property(nonatomic, strong) RACSubject *controllerShouldReloadDataSource;
@property(nonatomic) NSInteger selectedTabIndex;
@property(nonatomic) NSInteger reviewOrder;
@property(nonatomic) NSInteger dataSourceType;
@property(nonatomic, readonly, getter = getReviewTabIndex) NSNumber *reviewTabIndex;

- (RACSignal *)getTabCategories;
- (RACSignal *)getAllMenuItems;
- (void)getRatingsForMerchant;

- (NSInteger)numberOfItemsInCurrentDataSource;
- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath;
- (void)searchForItemWithValue:(NSString *)value;

@end
