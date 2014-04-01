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
#import "MMMerchant.h"
/**
 *  Allows us to have a reference to detect a click on the map
 *  popovers.
 */

@interface MMMapPopOverViewController : UIViewController
/**
 *  merchant that the pop over is describing
 */
@property(nonatomic, strong) MMMerchant *merchant;
/**
 *  Content View passed in to resize the view being displayed.
 */
@property(nonatomic, strong) UIView *contentView;

/**
 *  reference to the navigation controller from the split view
 */
@property(nonatomic, strong) UISplitViewController *parentSplitViewController;

/**
 *  Reference to the popover instantiated in the MapDelegate
 */
@property(nonatomic, strong) UIPopoverController *popOverController;

@end
