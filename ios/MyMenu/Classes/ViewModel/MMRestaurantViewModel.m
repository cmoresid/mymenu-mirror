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

#import "MMRestaurantViewModel.h"
#import "MMMerchant.h"
#import "MMMenuItem.h"
#import "MMMenuService.h"
#import "MMLoginManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

const NSInteger MMOrderByRecent = 0;
const NSInteger MMOrderByTopRated = 1;
const NSInteger MMMenuItemDataSource = 0;
const NSInteger MMReviewsDataSource = 1;

@interface MMRestaurantViewModel ()

@property(nonatomic, strong) NSArray *menuItemCategories;
@property(nonatomic, strong) NSArray *allMenuItems;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) RACMulticastConnection *retrieveMenuItemsConnection;
@property(nonatomic, strong) RACMulticastConnection *retrieveRecentReviewsConnection;
@property(nonatomic, strong) RACMulticastConnection *retrieveTopRatedReviewsConnection;
@property(nonatomic, strong) MMMenuService *menuService;
@property(nonatomic, readonly, getter = isOnReviewTabIndex) BOOL onReviewTabSegment;

@end

@implementation MMRestaurantViewModel

#pragma mark - Initializers

- (id)init {
    self = [super init];
    
    if (self) {
        self.menuService = [[MMMenuService alloc] init];
        self.retrieveMenuItemsConnection = nil;
        self.retrieveRecentReviewsConnection = nil;
        self.controllerShouldReloadDataSource = [RACSubject subject];
        self.controllerShouldShowProgressIndicator = [RACSubject subject];
        
        [self configureDataBindings];
    }
    
    return self;
}

- (void)configureDataBindings {
    @weakify(self);
    
    [RACObserve(self, selectedTabIndex)
        subscribeNext:^(NSNumber *selectedIndex) {
            @strongify(self);
            [self getDataSourceForSelectedIndex:selectedIndex];
    }];
    
    [[RACObserve(self, reviewOrder) skip:1]
        subscribeNext:^(NSNumber *reviewOrderBy) {
            @strongify(self);
            [self orderReviewsByCriteria:reviewOrderBy.integerValue];
    }];
}

#pragma mark - Custom Getter Methods for Properties

- (NSNumber *)getReviewTabIndex {
    return [NSNumber numberWithInteger:self.menuItemCategories.count - 1];
}

- (BOOL)isOnReviewTabIndex {
    return [[NSNumber numberWithInteger:self.selectedTabIndex] isEqualToNumber:self.reviewTabIndex];
}

#pragma mark - Network Retrieval Methods

- (RACSignal *)getTabCategories {
    [self configureMenuItemsConnection];
    [self.retrieveMenuItemsConnection connect];
    
    return [self.retrieveMenuItemsConnection.signal
        map:^NSArray*(NSMutableArray *menuItems) {
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithArray:[menuItems valueForKey:@"category"]];
            [orderedSet insertObject:NSLocalizedString(@"All Categories", nil) atIndex:0];
            [orderedSet insertObject:NSLocalizedString(@"Reviews", nil) atIndex:orderedSet.count];
        
            _menuItemCategories = [NSArray arrayWithArray:[orderedSet array]];
        
            return [_menuItemCategories copy];
    }];
}

- (RACSignal *)getAllMenuItems {
    [self configureMenuItemsConnection];
    [self.retrieveMenuItemsConnection connect];
    
    return [self.retrieveMenuItemsConnection.signal
        doNext:^(NSMutableArray *menuItems) {
            self.allMenuItems = [menuItems copy];
            self.dataSource = self.allMenuItems;
    }];
}

- (void)getRecentRatingsForMerchant {
    [self.controllerShouldShowProgressIndicator sendNext:@YES];
    
    [self configureRecentReviewsConnection];
    [self.retrieveRecentReviewsConnection connect];
    
    @weakify(self);
    [self.retrieveRecentReviewsConnection.signal
        subscribeNext:^(NSMutableArray *reviews) {
            @strongify(self);
            self.dataSource = [reviews copy];
        
            [self.controllerShouldShowProgressIndicator sendNext:@NO];
            [self.controllerShouldReloadDataSource sendNext:@YES];
    }];
}

- (void)getTopRatingsForMerchant {
    [self.controllerShouldShowProgressIndicator sendNext:@YES];
    
    [self configureTopRatedReviewsConnection];
    [self.retrieveTopRatedReviewsConnection connect];
    
    @weakify(self);
    [self.retrieveTopRatedReviewsConnection.signal
     subscribeNext:^(NSMutableArray *reviews) {
         @strongify(self);
         self.dataSource = [reviews copy];
         
         [self.controllerShouldShowProgressIndicator sendNext:@NO];
         [self.controllerShouldReloadDataSource sendNext:@YES];
     }];
}

#pragma mark - Search Methods

- (void)searchForItemWithValue:(NSString *)valueToSearchFor {
    if (self.onReviewTabSegment) return;
    
    if ([valueToSearchFor isEqualToString:@""]) {
        self.dataSource = [self getMenuItemsForSelectedCategory:self.selectedTabIndex];
        return;
    }
    
    self.dataSource = [self getMenuItemsForSelectedCategory:self.selectedTabIndex];
    RACSequence *filteredResults = [self.dataSource.rac_sequence
        filter:^BOOL(MMMenuItem *menuItem) {
            return [menuItem.name rangeOfString:valueToSearchFor options:NSCaseInsensitiveSearch].location != NSNotFound;
    }];
    
    self.dataSource = filteredResults.array;
}

#pragma mark - Data Source Methods

- (NSInteger)numberOfItemsInCurrentDataSource {
    return self.dataSource.count;
}

- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource objectAtIndex:indexPath.row];
}

#pragma mark - Configure Multicast Connections

- (void)configureMenuItemsConnection {
    if (self.retrieveMenuItemsConnection)
        return;
    
    MMUser *userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    NSString *userEmail = (userProfile != nil) ? userProfile.email : @"";
    
    RACSignal *retrieveMenuSignal = [self.menuService retrieveMenuFromMerchant:self.merchantInformation.mid forUser:userEmail];
    
    self.retrieveMenuItemsConnection = [retrieveMenuSignal multicast:[RACReplaySubject subject]];
}

- (void)configureRecentReviewsConnection {
    if (self.retrieveRecentReviewsConnection)
        return;
    
    RACSignal *retrieveReviewsSignal = [self.menuService retrieveRecentMenuItemReviewsForMerchant:self.merchantInformation.mid];
    
    self.retrieveRecentReviewsConnection = [retrieveReviewsSignal multicast:[RACReplaySubject subject]];
}

- (void)configureTopRatedReviewsConnection {
    if (self.retrieveTopRatedReviewsConnection)
        return;
    
    RACSignal *retrieveReviewsSignal = [self.menuService retrieveTopMenuItemReviewsForMerchant:self.merchantInformation.mid];
    
    self.retrieveTopRatedReviewsConnection = [retrieveReviewsSignal multicast:[RACReplaySubject subject]];
}

#pragma mark - Helper Methods

- (NSArray *)getMenuItemsForSelectedCategory:(NSInteger)categoryIndex {
    RACSequence *menuItemSequence = [self.allMenuItems.rac_sequence
        filter:^BOOL(MMMerchant *value) {
            NSString *categoryString = [_menuItemCategories objectAtIndex:categoryIndex];
                                         
            return ([value.category isEqualToString:categoryString] || [categoryString isEqualToString:NSLocalizedString(@"All Categories", nil)]);
    }];
    
    return menuItemSequence.array;
}

- (void)getDataSourceForSelectedIndex:(NSNumber *)selectedIndex {
    if ([selectedIndex isEqualToNumber:self.reviewTabIndex]) {
        self.dataSourceType = MMReviewsDataSource;
        
        self.dataSource = @[];
        [self.controllerShouldReloadDataSource sendNext:@YES];
        
        [self getRecentRatingsForMerchant];
    }
    else {
        self.dataSourceType = MMMenuItemDataSource;
        self.dataSource = [self getMenuItemsForSelectedCategory:selectedIndex.integerValue];
    }
}

- (void)orderReviewsByCriteria:(NSInteger)criteria {
    if (criteria == MMOrderByRecent) {
        [self getRecentRatingsForMerchant];
    }
    else {
        [self getTopRatingsForMerchant];
    }
}

@end
