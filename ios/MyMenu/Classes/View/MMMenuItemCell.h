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
#import "MMMenuItem.h"

/**
 *  A custom collection view cell that represents
 *  a menu item. The UI layout resides in an
 *  external XIB file, namely
 *  `Resources/XIB/MenuItemCell.xib`
 */
@interface MMMenuItemCell : UICollectionViewCell

/**
 *  The label that displays the name of
 *  the menu item.
 */
@property(nonatomic, weak) IBOutlet UITextView *titleView;

/**
 *  The label that displays the price of
 *  the menu item.
 */
@property(nonatomic, weak) IBOutlet UILabel *priceLabel;

/**
 *  The label that displays a brief description of
 *  the menu item.
 */
@property(nonatomic, weak) IBOutlet UITextView *descriptionView;

/**
 *  The label that displays the current rating for a
 *  menu item.
 */
@property(nonatomic, weak) IBOutlet UILabel *ratinglabel;

/**
 *  The label that displays whether or not a user can
 *  consume a menu item. An exclamation point is displayed
 *  in this label if a user cannot consume this menu item.
 */
@property(nonatomic, weak) IBOutlet UIImageView *restrictedImage;

/**
 *  The view that the rating label resides in. The background
 *  color for this view is set to a light grey color.
 */
@property(nonatomic, weak) IBOutlet UIView *ratingBg;

/**
 *  The image view where the picture of the menu item is
 *  loaded.
 */
@property(nonatomic, weak) IBOutlet UIImageView *menuImageView;

@end
