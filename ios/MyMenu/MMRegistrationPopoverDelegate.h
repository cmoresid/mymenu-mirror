//
//  MMRegistrationPopoverDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPopoverDataPair.h"

@protocol MMRegistrationPopoverDelegate <NSObject>

- (void)didSelectValue:(MMPopoverDataPair *)selectedValue;

@end
