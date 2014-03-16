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
#import "MMMenuItemRating.h"

/**
 *  A custom collection view cell that represents
 *  a menu item review. The UI layout resides in an
 *  external XIB file, namely
 *  `Resources/XIB/MenuItemReviewCell.xib`
 */
@interface MMMenuItemReviewCell : UICollectionViewCell

/**
 *  The menu item rating model object that this
 *  cell represents.
 */
@property MMMenuItemRating *rating;

/**
 *  The label that represents the name of the
 *  reviewer.
 */
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;

/**
 *  The label that contains a portion of the review
 *  that an individual has written.
 */
@property(nonatomic, weak) IBOutlet UILabel *reviewLabel;

/**
 *  The label that contains the rating that a reviewer
 *  has given a menu item.
 */
@property(nonatomic, weak) IBOutlet UILabel *ratinglabel;

/**
 *  The view that the rating label resides in. The background
 *  color for this view is set to a light grey color.
 */
@property(nonatomic, weak) IBOutlet UIView *ratingBg;

/**
 *  An image view that contains the image for the 'up vote'
 *  button.
 */
@property(nonatomic, weak) IBOutlet UIImageView *likeImageView;

/**
 *  The label that contains the number of 'up votes' that
 *  a review has.
 */
@property(nonatomic, weak) IBOutlet UILabel *upVoteCountLabel;

@end

