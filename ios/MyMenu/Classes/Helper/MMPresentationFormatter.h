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

/**
 *  A helper class that can format
 *  model data into something suitable
 *  for the UI.
 */
@interface MMPresentationFormatter : NSObject

/**
 *  Takes a rating from an `MMMerchant` or
 *  `MMMenuItem` and formats the number as
 *  with 2 significant digits. A rating of
 *  0 is formatted an 'N/A'
 *
 *  @param rating The rating from the model.
 *
 *  @return A string formatted representation of
 *          the rating.
 */
+ (NSString *)formatRatingForRawRating:(NSNumber *)rating;

/**
 *  Formats a merchant's business hours in
 *  an appropriate format.
 *
 *  @param openTime  The open-time of a merchant.
 *  @param closeTime The close-time of a merchant.
 *
 *  @return A UI appropriate string that represents
 *          a merchant's business hours.
 */
+ (NSString *)formatBusinessHoursForOpenTime:(NSString *)openTime withCloseTime:(NSString *)closeTime;

/**
 *  Provides a UI appropriate formatting
 *  for a model's price.
 *
 *  @param price A price.
 *
 *  @return A UI appropriate string that represents
 *          a model's price.
 */
+ (NSString *)formatNumberAsPrice:(NSNumber *)price;

/**
 *  Returns a string which represens a distance 
 *  in a UI appropriate format. If a distance
 *  is under 1.0 km, the distance is formatted
 *  in metres; if greater that or equal to 1.0 km,
 *  the distance is formatted in kilometers.
 *
 *  @param distance A distance
 *
 *  @return A UI formatted representation of
 *          a distance.
 */
+ (NSString *)formatDistance:(NSNumber *)distance;

@end
