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
#import <ReactiveCocoa/ReactiveCocoa.h>

const NSInteger MMMenuItemDataSource = 0;
const NSInteger MMReviewDataSource = 1;

@interface MMRestaurantViewModel () {
    NSArray *_menuItemCategories;
    NSArray *_menuItems;
    NSArray *_menuItemReviews;
}

@end

@implementation MMRestaurantViewModel

- (NSInteger)numberOfTabCategories {
    return [_menuItemCategories count];
}

- (RACSignal *)getTabCategories {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (NSInteger)numberOfItemsInCurrentDataSource {
    if (self.currentDataSourceType == MMMenuItemDataSource) {
        return [self getMenuItemsForSelectedCategory:self.selectedTabIndex].count;
    }
    else {
        return 0;
    }
}

- (id)getItemFromCurrentDataSourceForIndex:(NSInteger)indexPath {
    if (self.currentDataSourceType == MMMenuItemDataSource) {
        return [[self getMenuItemsForSelectedCategory:self.selectedTabIndex] objectAtIndex:indexPath];
    }
    else {
        return nil;
    }
}

- (NSArray *)getMenuItemsForSelectedCategory:(NSInteger)categoryIndex {
    return [_menuItems.rac_sequence filter:^BOOL(MMMerchant *value) {
        NSString *categoryString = [_menuItemCategories objectAtIndex:categoryIndex];
        
        return ([value.category isEqualToString:categoryString] || [categoryString isEqualToString:NSLocalizedString(@"All Categories", nil)]);
    }].array;
}

@end
