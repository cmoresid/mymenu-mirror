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

typedef NS_ENUM(NSInteger, MMPopoverDataType) {
    CityValue = 0,
    ProvinceValue = 1,
    GenderValue = 2,
    BirthdayValue = 3,
    CategoryValue = 4
};

@interface MMPopoverDataPair : NSObject

@property(readwrite) MMPopoverDataType dataType;
@property(readwrite) id selectedValue;

- (id)initWithDataType:(MMPopoverDataType)dataType withSelectedValue:(id)selectedValue;

@end
