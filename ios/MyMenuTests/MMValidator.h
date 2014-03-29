//
//  MMMenuItemValidator.h
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-03-27.
//
//

#import <Foundation/Foundation.h>
@class MMMenuItem;
@interface MMValidator : NSObject

+(BOOL)isValidMenuItem:(MMMenuItem *) item;

@end
