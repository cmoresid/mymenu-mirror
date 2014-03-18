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

#import <Foundation/Foundation.h>

@class MMDBFetcher;
@class RACSignal;

/**
 *  Provides an additional layer over top
 *  of `MMDBFetcher`. This class functions
 *  as the the 'Service Layer'.
 */
@interface MMMenuService : NSObject

/**
 *  Retrieves a customized menu from the specified merchant
 *  for a given user.
 *
 *  @param merchId   The merchant ID.
 *  @param userEmail The user's email.
 *
 *  @return An `NSMutableArray` of `MMMenuItem` objects.
 */
- (RACSignal *)retrieveMenuFromMerchant:(NSNumber *)merchId forUser:(NSString *)userEmail;

/**
 *  Retrieves a list of menu item reviews for a
 *  given merchant.
 *
 *  @param merchId The merchant ID.
 *
 *  @return An `NSMutableArray` of `MMMenuRating` objects.
 */
- (RACSignal *)retrieveRecentMenuItemReviewsForMerchant:(NSNumber *)merchId;


- (RACSignal *)retrieveTopMenuItemReviewsForMerchant:(NSNumber *)merchId;


@end
