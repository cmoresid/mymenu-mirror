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
#import "MMPopoverDataPair.h"

/**
 * A delegate that is used by `MMRestaurantViewController` and
 * the `MMRestaurantPopOverViewController` so the popover view
 * controller can send values back to the `MMRestaurantViewController`.
 */
@protocol MMReviewPopOverDelegate <NSObject>

@optional

/**
 * Sends the selected category from the popover
 * controller back to the parent view controller.
 *
 * @param category The string value of the category
 *                 selected.
 */
- (void)didSelectDone:(BOOL)done;

- (void)didSelectCancel:(BOOL)cancel;

@end