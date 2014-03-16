//
//  MMRestaurantViewModel.h
//  MyMenu
//
//  Created by Connor Moreside on 3/14/2014.
//
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

- (RACSignal *)formatRatingForRawRating:(NSNumber *)rating;
- (RACSignal *)formatBusinessHoursForOpenTime:(NSString *)openTime withCloseTime:(NSString *)closeTime;

- (NSInteger)numberOfItemsInCurrentDataSource;
- (id)getItemFromCurrentDataSourceForIndexPath:(NSIndexPath *)indexPath;
- (void)searchForItemWithValue:(NSString *)value;

@end
