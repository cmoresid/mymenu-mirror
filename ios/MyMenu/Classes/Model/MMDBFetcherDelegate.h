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

#import <Foundation/Foundation.h>
#import "MMDBFetcherResponse.h"
#import "MMUser.h"
#import "MMMerchant.h"


@protocol MMDBFetcherDelegate <NSObject>

@optional
- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response;

- (void)doesUserExist:(BOOL)exists withResponse:(MMDBFetcherResponse *)response;

- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveUser:(MMUser *)user withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveSpecials:(NSArray *)specials withResponse:(MMDBFetcherResponse *)response  __deprecated;

- (void)didRetrieveSpecials:(NSArray *)specials forDate:(NSDate *) date withResponse:(MMDBFetcherResponse *)response;

- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response;

- (void)didRemoveAllUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveCompressedMerchants:(NSArray *)compressedMerchants withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveMenuItems:(NSArray *)menuItems withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveAllRestrictions:(NSArray *)allRestrictions withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveUserRestrictions:(NSArray *)userRestrictions withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveMerchant:(MMMerchant *)merchant withResponse:(MMDBFetcherResponse *)response;

- (void)didUpdateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveModifications:(NSArray *)modificationsArray withResponse:(MMDBFetcherResponse *)response;

- (void)didCreateRating:(BOOL)successful withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveTopItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveRecentItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response;

- (void)didRetrieveCategories:(NSArray *)categories withResponse:(MMDBFetcherResponse *)response;

- (void)didAddEatenThis:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response;

- (void)didAddReviewLike:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response;

- (void)didAddReviewReport:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response;

- (void)didUserEat:(BOOL)exists withResponse:(MMDBFetcherResponse *)response;

- (void)didUserLike:(BOOL)exists withResponse:(MMDBFetcherResponse *)response;

- (void)didUserReport:(BOOL)exists withResponse:(MMDBFetcherResponse *)response;

- (void)didUpdateRatings:(BOOL)exists withResponse:(MMDBFetcherResponse *)response;

@end
