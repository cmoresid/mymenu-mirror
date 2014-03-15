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

@interface MMRestaurantViewModel ()

@property (nonatomic, strong) NSArray *menuItemCategories;
@property (nonatomic, strong) NSArray *allMenuItems;
@property (nonatomic, strong) NSArray *allMenuItemReviews;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) RACMulticastConnection *retrieveMenuItemsConnection;
@property (nonatomic, strong) MMMenuService *menuService;
@property (nonatomic, readonly, getter = isOnReviewTabIndex) BOOL onReviewTabSegment;

@end

@implementation MMRestaurantViewModel

- (BOOL)isOnReviewTabIndex {
    BOOL result = (self.selectedTabIndex == self.menuItemCategories.count - 1);
    return result;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.menuService = [[MMMenuService alloc] init];
        self.retrieveMenuItemsConnection = nil;
        
        @weakify(self);
        RAC(self, dataSource) = [[RACObserve(self, selectedTabIndex)
            filter:^BOOL(NSNumber *value) {
                @strongify(self);
            
                return !self.onReviewTabSegment;
            }] map:^NSArray*(id value) {
                @strongify(self);
                
                return [self getMenuItemsForSelectedCategory:self.selectedTabIndex];
            }];
    }
    
    return self;
}

- (NSInteger)numberOfTabCategories {
    return [_menuItemCategories count];
}

- (RACSignal *)getTabCategories {
    [self configureMulticastConnection];
    [self.retrieveMenuItemsConnection connect];
    
    return [self.retrieveMenuItemsConnection.signal map:^NSArray*(NSMutableArray *menuItems) {
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithArray:[[menuItems copy]valueForKey:@"category"]];
        [orderedSet insertObject:NSLocalizedString(@"All Categories", nil) atIndex:0];
        [orderedSet insertObject:NSLocalizedString(@"Reviews", nil) atIndex:orderedSet.count];
        
        _menuItemCategories = [NSArray arrayWithArray:[orderedSet array]];
        
        return [_menuItemCategories copy];
    }];
}

- (RACSignal *)getAllMenuItems {
    [self configureMulticastConnection];
    [self.retrieveMenuItemsConnection connect];
    
    @weakify(self);
    return [self.retrieveMenuItemsConnection.signal doNext:^(NSMutableArray *menuItems) {
        @strongify(self);
        self.allMenuItems = [menuItems copy];
        self.dataSource = self.allMenuItems;
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

- (void)configureMulticastConnection {
    if (self.retrieveMenuItemsConnection)
        return;
    
    NSInteger merchantID = self.merchantInformation.mid.integerValue;
    MMUser *userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    NSString *userEmail = (userProfile != nil) ? userProfile.email : @"";
    
    RACSignal *retrieveMenuSignal = [self.menuService retrieveMenuFromMerchant:merchantID forUser:userEmail];
    self.retrieveMenuItemsConnection = [retrieveMenuSignal multicast:[RACReplaySubject subject]];
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
