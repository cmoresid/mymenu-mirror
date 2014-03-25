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

@class SLComposeViewController;
@class MMMenuItem;

/**
 *  A helper class that is a wrapper 
 *  around `SLComposeViewController`
 *  that allows a user to share MyMenu
 *  related content.
 */
@interface MMSocialMediaService : NSObject

/**
 *  A helper method that configures an
 *  `SLComposeViewController` to share
 *  a menu item. A view controller must
 *  then present the returned view controller.
 *
 *  @param menuItem    The menu item to share.
 *
 *  @return A `UIViewController` that is
 *          configured to share the provided menu
 *          item.
 *
 *  See `presentViewController:animated:completion:`
 *  of `UIViewController` to use the resulting
 *  `SLComposeViewController`.
 */
+ (UIViewController *)shareMenuItem:(MMMenuItem *)menuItem;

@end
