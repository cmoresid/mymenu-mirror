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
 * Represents the type of data returned
 * from as a result of the `MMRegistrationPopoverViewController`.
 */
typedef NS_ENUM(NSInteger, MMPopoverDataType) {
    CityValue = 0,
    ProvinceValue = 1,
    GenderValue = 2,
    BirthdayValue = 3,
    CategoryValue = 4
};

/**
 * Represents a value that is returned from a `MMResgistrationPopoverViewController`
 */
@interface MMPopoverDataPair : NSObject

/**
 * The type of data returned from the popover view controller.
 */
@property(readwrite) MMPopoverDataType dataType;

/**
 * The value that was selected in the popover view controller.
 */
@property(readwrite) id selectedValue;

/**
 * Constructor that creates a data pair that describes the
 * data type and the selected value.
 *
 * @param dataType The data type.
 * @param selectedValue The selected value.
 */
- (id)initWithDataType:(MMPopoverDataType)dataType withSelectedValue:(id)selectedValue;

@end
