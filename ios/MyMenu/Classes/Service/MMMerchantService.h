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

@class RACSignal;
@class CLLocation;

/**
 *  Provides an additional layer over top
 *  of `MMDBFetcher`. This class functions
 *  as the the 'Service Layer'.
 */
@interface MMMerchantService : NSObject

/**
 *  Retrieves the singleton of this
 *  class.
 *
 *  @return A `MMMerchantService` object which
 *          is a singleton of this class.
 */
+ (instancetype)sharedService;

/**
 *  Retrieves the merchant that corresponds
 *  with the given merchant ID.
 *
 *  @param merchantId The ID of the merchant to retrive.
 *
 *  @return An `MMMerchant` object.
 */
- (RACSignal *)getMerchantWithMerchantID:(NSNumber *)merchantId;

/**
 *  Retrieves a list of merchants that are within a certain
 *  threshold of the specified location. The merchant objects
 *  only contain a subset of the available information for
 *  a merchant object.
 *
 *  @param location The location object.
 *
 *  @return A `NSMutableArray` of `MMMerchant` objects.
 */
- (RACSignal *)getDefaultCompressedMerchantsForLocation:(CLLocation *)location;

/**
 *  Retrieves a list of merchants that are within a certain threshold of
 *  the given location. Also, the list of merchants must be either a partial
 *  or full match to the given merchant name. Again, the information returned
 *  is only a subset of the available information for a merchants.
 *
 *  @param location     The location.
 *  @param merchantName The merchant name to search for.
 *
 *  @return An `NSMutableArray` of `MMerchant` objects.
 */
- (RACSignal *)getCompressedMerchantsForLocation:(CLLocation *)location withName:(NSString *)merchantName;

/**
 *  Retrieves a list of merchants that are within a certain threshold of
 *  the given location. Also, the list of merchants must server the type
 *  of cusine that is specifed. Again, the information returned
 *  is only a subset of the available information for a merchants.
 *
 *  @param location The location.
 *  @param cuisine  The type of cusine.
 *
 *  @return An `NSMutableArray` of `MMerchant` objects.
 */
- (RACSignal *)getCompressedMerchantsForLocation:(CLLocation *)location withCuisineType:(NSString *)cuisine;

@end
