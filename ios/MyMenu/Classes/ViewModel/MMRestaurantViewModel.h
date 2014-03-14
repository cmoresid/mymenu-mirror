//
//  MMRestaurantViewModel.h
//  MyMenu
//
//  Created by Connor Moreside on 3/14/2014.
//
//

#import "RVMViewModel.h"

extern const NSInteger MMMenuItemDataSource;
extern const NSInteger MMReviewDataSource;

@class MMMerchant;

@interface MMRestaurantViewModel : RVMViewModel

@property(nonatomic, strong) MMMerchant *merchantInformation;
@property(nonatomic) NSInteger currentDataSourceType;
@property(nonatomic) NSInteger selectedTabIndex;

- (RACSignal *)getTabCategories;

- (NSInteger)numberOfItemsInCurrentDataSource;
- (id)getItemFromCurrentDataSourceForIndex:(NSInteger)index;

@end
