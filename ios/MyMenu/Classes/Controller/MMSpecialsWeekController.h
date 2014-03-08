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
#import "MMSpecialsCollectionViewController.h"

/**
 *  Controller for showing the weeks we can show to the user in the specials view
 */
@interface MMSpecialsWeekController : UITableViewController

/**
 *  Weeks from date
 */
@property(nonatomic,readwrite) NSArray * weeks;

/**
 *   The selected week
 */
@property(nonatomic) NSUInteger selectedWeek;

/**
 *  The controller we are in (Always MMSpecialsCollectionViewController)
 */
@property(nonatomic,readwrite) MMSpecialsCollectionViewController * specialsCollectionController;

/**
 *  Required height for the tableview
 *
 *  @return CGSize use in View.
 */
- (CGSize)contentSizeForViewInPopover;

@end
