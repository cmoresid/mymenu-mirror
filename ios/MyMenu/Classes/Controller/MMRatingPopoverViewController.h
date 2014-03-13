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

@class MMRatingView;
@class MMMenuItem;
@class MMMerchant;

typedef void (^RatingsReturnBlock)(NSNumber *);

/**
 *  The rating popover which shows the circle rating.
 */
@interface MMRatingPopoverViewController : UIViewController

/**
 *  The Rating view
 */
@property(nonatomic, weak) IBOutlet MMRatingView *ratingView;

/**
 *  The current rating
 */
@property(nonatomic, assign) CGFloat currentRating;

/**
 *  Label to show restaurnt who the menu item belongs to
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantName;

/**
 *  The Menu item which is being rated
 */
@property(nonatomic, weak) IBOutlet UILabel *menuItemName;

/**
 *  A picture of the menu item view
 */
@property(nonatomic, weak) IBOutlet UIImageView *menuItemImage;
/**
 *  reference to the cancel button
 */
@property(nonatomic, weak) IBOutlet UIButton *cancelButton;

/**
 *  reference to the done button
 */
@property(nonatomic, weak) IBOutlet UIButton *doneButton;

/**
 *  The current menu item
 */
@property(nonatomic, strong) MMMenuItem *menuItem;

/**
 *  The Current menu item merchant
 */
@property(nonatomic, strong) MMMerchant *menuItemMerchant;
/**
 *
 */
@property(nonatomic, strong) UIView *oldView;

/**
 *  The rating the user selected.
 */
@property(nonatomic, copy) RatingsReturnBlock selectedRating;

/**
 *  Close the rating box, and return nothing.
 */
@property(nonatomic, copy) RatingsReturnBlock cancelRating;


/**
 *  Save the rating the user selected
 *
 *  @param sender UIButton
 */
- (IBAction)submitReview:(id)sender;

/**
 *  Cancel the input of a rating
 *
 *  @param sender UIButton
 */
- (IBAction)cancelReview:(id)sender;

/**
 *  Move the rating wheel based on touched point.
 *
 *  @param touchLocation CGPoint
 */
- (void)moveRatingWheelWithTouch:(CGPoint)touchLocation;

/**
 * Called when the back button on the navigation bar is pressed
 */
-(IBAction)backButtonPressed:(id)sender;

@end
