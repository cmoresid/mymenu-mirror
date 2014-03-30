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
 *  A helper singleton that retrieves key-value
 *  pairs from Resources/Data/StaticData.plist. Place
 *  any sort of static data, such as URLs that are
 *  non-region related.
 */
@interface MMStaticDataHelper : NSObject

/**
 *  Retrieves the singleton instance for
 *  this class.
 *
 *  @return The singleton instance.
 */
+ (MMStaticDataHelper *)sharedDataHelper;

/**
 *  Retrieves the URL for the About page on
 *  mymenuapp.ca.
 *
 *  @return The URL of the About page.
 */
- (NSString *)getAboutURL;

/**
 *  Retrieves an array of image names that
 *  correspond to the selected images for
 *  the tab bar.
 *
 *  @return An array of image file names.
 */
- (NSArray *)getSelectedTabBarImageNames;

@end
