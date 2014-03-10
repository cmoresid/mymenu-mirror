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

#import <UIKit/UIKit.h>

/**
 * Colors for our color scheme as provided by the designer.
 */
@interface UIColor (MyMenuColors)

/**
 *  The main teal color used in the application.
 *
 *  @return rgb(67.0, 199.0, 174.0)
 */
+ (UIColor *)tealColor;

/**
 *  The dark teal color used in the navigation bar.
 *
 *  @return rgb(41.0, 169.0, 149.0)
 */
+ (UIColor *)darkTealColor;

/**
 *  The light teal color used as an accent.
 *
 *  @return rgb(136.0, 221.0, 207.0)
 */
+ (UIColor *)lightTealColor;

/**
 *  The orange used as an accent.
 *
 *  @return rgb(233.0, 182.0, 83.0)
 */
+ (UIColor *)accentOrangeColor;

/**
 *  The red accent color provided by the UI designer.
 *
 *  @return rgb(204.0, 69.0, 85.0)
 */
+ (UIColor *)accentRedColor;

/**
 *  The sidebar grey color.
 *
 *  @return rgb(91.0, 91.0, 91.0)
 */
+ (UIColor *)sidebarBackgroundGray;

/**
 *  A subtle grey color that can be used
 *  in the background.
 *
 *  @return rgb(179.0, 179.0, 179.0)
 */
+ (UIColor *)lightBackgroundGray;

/**
 *  A light blue color that is used for
 *  highlighting.
 *
 *  @return rgb(236.0, 249.0, 247.0)
 */
+ (UIColor *)lightBlueHighlight;

/**
 *  A secondary blue color in color palette.
 *
 *  @return rgb(142.0, 221.0, 206.0)
 */
+ (UIColor *)secondaryBlueBar;

@end
