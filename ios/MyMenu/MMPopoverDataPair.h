//
//  MMPopoverDataPair.h
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMPopoverDataType) {
    CityValue = 0,
    ProvinceValue = 1,
    GenderValue = 2,
    BirthdayValue = 3
};

@interface MMPopoverDataPair : NSObject

@property (readwrite) MMPopoverDataType dataType;
@property (readwrite) id selectedValue;

- (id)initWithDataType:(MMPopoverDataType)dataType withSelectedValue:(id)selectedValue;

@end
