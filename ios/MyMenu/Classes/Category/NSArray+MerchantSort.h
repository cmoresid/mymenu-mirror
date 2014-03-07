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
 * An extension (category) method to `NSArray` so
 * one can sort an array of `MMMerchUser` by a
 * number of criteria.
 */
@interface NSArray (MerchantSort)

/**
 * Sort an array of merchant users by
 * distance from the user.
 */
- (NSArray *)sortMerchantByDistance;

/**
 * Sort an array of merchant users by
 * rating in descending order (top rated
 * to lowest rating).
 */
- (NSArray *)sortMerchantByTopRated;

/**
 * Sort an array of merchant users by
 * cusine type.
 */
- (NSArray *)sortMerchantByCusine;

@end
