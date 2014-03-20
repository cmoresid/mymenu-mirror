//
//  UISearchBar+RAC.h
//  ReactiveCocoaExample
//
//  Created by Justin DeWind on 1/26/14.
//  Copyright (c) 2014 Justin DeWind. All rights reserved.
//
//  https://github.com/dewind/ReactiveCocoaExample

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UISearchBar (RAC)

- (RACSignal *)rac_textSignal;

@end
