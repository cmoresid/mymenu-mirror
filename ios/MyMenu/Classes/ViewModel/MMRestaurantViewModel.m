//
//  MMRestaurantViewModel.m
//  MyMenu
//
//  Created by Connor Moreside on 3/14/2014.
//
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
@property(nonatomic, strong) NSArray *allMenuItemReviews;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) RACMulticastConnection *retrieveMenuItemsConnection;
@property(nonatomic, strong) RACMulticastConnection *retrieveReviewsConnection;
@property(nonatomic, strong) MMMenuService *menuService;
@property(nonatomic, readonly, getter = isOnReviewTabIndex) BOOL onReviewTabSegment;

@end

@implementation MMRestaurantViewModel

- (NSNumber *)getReviewTabIndex {
    return [NSNumber numberWithInteger:self.menuItemCategories.count - 1];
}

- (BOOL)isOnReviewTabIndex {
    return [[NSNumber numberWithInteger:self.selectedTabIndex] isEqualToNumber:self.reviewTabIndex];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.menuService = [[MMMenuService alloc] init];
        self.retrieveMenuItemsConnection = nil;
        self.retrieveReviewsConnection = nil;
        self.controllerShouldReloadDataSource = [RACSubject subject];
        self.controllerShouldShowProgressIndicator = [RACSubject subject];
        
        @weakify(self);
        RAC(self, dataSource) = [[RACObserve(self, selectedTabIndex)
            filter:^BOOL(NSNumber *selectedIndex) {
                @strongify(self);
                return ![selectedIndex isEqualToNumber:self.reviewTabIndex];
            }]
            map:^NSArray*(NSNumber *selectedTabIndex) {
                @strongify(self);
                self.dataSourceType = MMMenuItemDataSource;
                
                return [self getMenuItemsForSelectedCategory:selectedTabIndex.integerValue];
            }];
        
        [[RACObserve(self, selectedTabIndex)
            filter:^BOOL(NSNumber *selectedIndex) {
                @strongify(self);
                return [selectedIndex isEqualToNumber:self.reviewTabIndex];
            }]
            subscribeNext:^(id x) {
                @strongify(self);
                self.dataSourceType = MMReviewsDataSource;

                self.dataSource = @[];
                [self.controllerShouldReloadDataSource sendNext:@YES];
                
                [self getRatingsForMerchant];
            }
         ];
        
        [RACObserve(self, reviewOrder) subscribeNext:^(NSNumber *reviewOrderBy) {
            @strongify(self);
            if (!self.allMenuItemReviews) return;
            
            if (reviewOrderBy.intValue == MMOrderByRecent) {
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                             ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                self.dataSource = [self.allMenuItemReviews sortedArrayUsingDescriptors:sortDescriptors];
                [self.controllerShouldReloadDataSource sendNext:@YES];
            }
            else {
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating"
                                                             ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                self.dataSource = [self.allMenuItemReviews sortedArrayUsingDescriptors:sortDescriptors];
                [self.controllerShouldReloadDataSource sendNext:@YES];
            }
        }];
    }
    
    return self;
}

- (BOOL)areWeRetrievingReviewsFromNetwork {
    return self.allMenuItemReviews == nil;
}

- (RACSignal *)getTabCategories {
    [self configureMenuItemsConnection];
    [self.retrieveMenuItemsConnection connect];
    
    return [self.retrieveMenuItemsConnection.signal map:^NSArray*(NSMutableArray *menuItems) {
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
    
    return [self.retrieveMenuItemsConnection.signal doNext:^(NSMutableArray *menuItems) {
        self.allMenuItems = [menuItems copy];
        self.dataSource = self.allMenuItems;
    }];
}

- (void)getRatingsForMerchant {
    if (![self areWeRetrievingReviewsFromNetwork]) {
        self.dataSource = self.allMenuItemReviews;
        [self.controllerShouldReloadDataSource sendNext:@YES];

        return;
    }
    
    [self.controllerShouldShowProgressIndicator sendNext:@YES];
    [self configureReviewsConnection];
    [self.retrieveReviewsConnection connect];
    
    @weakify(self);
    [self.retrieveReviewsConnection.signal subscribeNext:^(NSMutableArray *reviews) {
        @strongify(self);
        self.allMenuItemReviews = [reviews copy];
        self.dataSource = self.allMenuItemReviews;
        
        [self.controllerShouldShowProgressIndicator sendNext:@NO];
        [self.controllerShouldReloadDataSource sendNext:@YES];
    }];
}

- (RACSignal *)formatRatingForRawRating:(NSNumber *)rating {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    
    NSString *rate = [formatter stringFromNumber:rating];
    
    return [RACSignal return:([rate isEqualToString:@".0"] ? @"N/A" : rate)];
}

- (RACSignal *)formatBusinessHoursForOpenTime:(NSString *)openTime withCloseTime:(NSString *)closeTime {
    NSString *formattedOpenTime = [openTime substringToIndex:[openTime length] - 3];
    NSString *formattedCloseTime = [closeTime substringToIndex:[closeTime length] - 3];
                          
    return [RACSignal return:[NSString stringWithFormat:@"%@ - %@", formattedOpenTime, formattedCloseTime]];

}

- (void)searchForItemWithValue:(NSString *)value {
    if (self.onReviewTabSegment) return;
    
    if ([value isEqualToString:@""]) {
        self.dataSource = [self getMenuItemsForSelectedCategory:self.selectedTabIndex];
        return;
    }
    
    self.dataSource = [self.dataSource.rac_sequence filter:^BOOL(MMMenuItem *menuItem) {
        return [[menuItem.name lowercaseString] rangeOfString:value].location != NSNotFound;
    }].array;
}

- (void)configureMenuItemsConnection {
    if (self.retrieveMenuItemsConnection)
        return;
    
    MMUser *userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    NSString *userEmail = (userProfile != nil) ? userProfile.email : @"";
    
    RACSignal *retrieveMenuSignal = [self.menuService retrieveMenuFromMerchant:self.merchantInformation.mid forUser:userEmail];
    
    self.retrieveMenuItemsConnection = [retrieveMenuSignal multicast:[RACReplaySubject subject]];
}

- (void)configureReviewsConnection {
    if (self.retrieveReviewsConnection)
        return;
    
    RACSignal *retrieveReviewsSignal = [self.menuService retrieveMenuItemReviewsForMerchant:self.merchantInformation.mid];
    
    self.retrieveReviewsConnection = [retrieveReviewsSignal multicast:[RACReplaySubject subject]];
}

- (NSInteger)numberOfItemsInCurrentDataSource {
    return self.dataSource.count;
}

- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (NSArray *)getMenuItemsForSelectedCategory:(NSInteger)categoryIndex {
    return [self.allMenuItems.rac_sequence filter:^BOOL(MMMerchant *value) {
        NSString *categoryString = [_menuItemCategories objectAtIndex:categoryIndex];
        
        return ([value.category isEqualToString:categoryString] || [categoryString isEqualToString:NSLocalizedString(@"All Categories", nil)]);
    }].array;
}

@end
