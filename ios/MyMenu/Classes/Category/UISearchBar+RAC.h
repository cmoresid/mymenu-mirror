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

/**
 *  Adds ReactiveCocoa support to search bars
 */
@interface UISearchBar (RAC)

/**
 *  A signal that is emitted when the text in
 *  a search bar is updated by a user. Is not
 *  emitted if `text` property of search bar is
 *  edited programatically.
 */
- (RACSignal *)rac_textSignal;

@end
