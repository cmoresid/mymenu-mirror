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
 *  A custom segue that does not use any
 *  sort of transition animation. It used
 *  primarily as the segue between the
 *  dietary restrictions page and the main
 *  tab bar view. It is also used for
 *  the transition between the login view
 *  and the main tab bar view when the app
 *  starts up.
 */
@interface MMMainTabViewSegue : UIStoryboardSegue

@end
