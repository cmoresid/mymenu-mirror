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
 * A delegate protocol used by the `MMRegistrationPopoverViewController`
 * to interact with the `MMRegistrationViewConroller`. The values chosen
 * within the popover view controller can be sent back to the parent
 * view controller.
 */
@protocol MMRegistrationPopoverDelegate <NSObject>

@optional

/**
 * Send the selected value of the city from
 * the popover view controller to the parent
 * view controller.
 *
 * @param city The city that was selected.
 */
- (void)didSelectCity:(NSString *)city;

/**
 * Send the selected value of the province from
 * the popover view controller to the parent
 * view controller.
 *
 * @param province The province that was selected.
 */
- (void)didSelectProvince:(NSString *)province;

/**
 * Send the selected gender from
 * the popover view controller to the parent
 * view controller.
 *
 * @param gender The gender that was selected.
 */
- (void)didSelectGender:(NSString *)gender;

/**
 * Send the selected value of the birthday from
 * the popover view controller to the parent
 * view controller.
 *
 * @param birthday The date value of the birthday 
 *                 that was selected.
 */
- (void)didSelectBirthday:(NSDate *)birthday;

@end
