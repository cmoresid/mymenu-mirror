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
 *  A category for `UIStoryboard` that provides
 *  helper methods to retrieve the various storyboards
 *  used by the application.
 */
@interface UIStoryboard (UIStoryboard_MyMenu)

/**
 *  Retrieves a reference to the main storyboard
 *  used in the application. (Main.storyboard)
 *
 *  @return The main storyboard.
 */
+ (UIStoryboard*)mainStoryBoard;

/**
 *  Retrieves a reference to the specials storyboard
 *  used in the application. (Specials.storyboard)
 *
 *  @return The specials storyboard.
 */
+ (UIStoryboard*)specialsStoryboard;

/**
 *  Retrieves a reference to the menu storyboard
 *  used in the application. (Menu.storyboard)
 *
 *  @return The menu storyboard.
 */
+ (UIStoryboard*)menuStoryboard;

/**
 *  Retrieves a reference to the profile storyboard
 *  used in the application. (Profile.storyboard)
 *
 *  @return The profile storyboard.
 */
+ (UIStoryboard*)profileStoryboard;

@end
