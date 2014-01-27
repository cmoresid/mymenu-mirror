//
//  MMPopoverDataPair.m
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMPopoverDataPair.h"

@implementation MMPopoverDataPair

- (id) initWithDataType:(MMPopoverDataType)dataType withSelectedValue:(id)selectedValue
{
    self = [super init];
    
    if (self != nil) {
        self.dataType = dataType;
        self.selectedValue = selectedValue;
    }
    
    return self;
}

@end
