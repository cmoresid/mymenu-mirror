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
@property(nonatomic) NSInteger selectedTabIndex;

- (RACSignal *)getTabCategories;
- (RACSignal *)getAllMenuItems;

- (RACSignal *)formatRatingForRawRating:(NSNumber *)rating;
- (RACSignal *)formatBusinessHoursForOpenTime:(NSString *)openTime withCloseTime:(NSString *)closeTime;

- (NSInteger)numberOfItemsInCurrentDataSource;
- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath;
- (void)searchForItemWithValue:(NSString *)value;

@end
