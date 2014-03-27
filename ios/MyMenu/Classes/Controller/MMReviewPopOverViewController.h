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
#import "MMMenuItem.h"
#import "MMRatingPopoverViewController.h"
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMBaseNavigationController.h"

@class MMMenuItemRating;

typedef void (^FinishCallback)(BOOL);

/**
 *  View Controller for the popover that is created
 *  when a user selects a review collection view
 *  cell.
 */
@interface MMReviewPopOverViewController : UIViewController <UIPopoverControllerDelegate, MMDBFetcherDelegate>
/**
 *  Number that is kept as the current rating for a review
 */
@property(nonatomic, assign) CGFloat currentRating;
/**
 *  Reference to a UILabel containing the Merchant Name
 */
@property(nonatomic, weak) IBOutlet UILabel *restaurantName;
/**
 *  Reference to a UILabel containgin the Menu Item Name
 */
@property(nonatomic, weak) IBOutlet UILabel *menuItemName;
/**
 *  Reference to the menu Item picture
 */
@property(nonatomic, weak) IBOutlet UIImageView *menuItemImage;
/**
 *  Reverence to the text view that contains the menu item
 *  description
 */
@property(nonatomic, weak) IBOutlet UITextView *desc;
/**
 *  Reference to the Like button
 */
@property(nonatomic, weak) IBOutlet UIButton *like;
/**
 *  Reference to the Report button
 */
@property(nonatomic, weak) IBOutlet UIButton *report;
/**
 *  Reference to the Edit button
 */
@property(nonatomic, weak) IBOutlet UIButton *edit;
/**
 *  Reference to the UILabel that contains the amount
 *  of times something has been liked
 */
@property(nonatomic, weak) IBOutlet UILabel *likecount;
/**
 *  Reference to the background for the rating display
 */
@property(nonatomic, weak) IBOutlet UIView *labelBack;
/**
 *  Reference to the UILabel that displays the 
 *  rating of the item
 */
@property(nonatomic, weak) IBOutlet UILabel *ratingLabel;

/**
 *  Reference to the Navigation Controller that is used throughout
 *  the app.
 */
@property(nonatomic, strong) MMBaseNavigationController *popOverNavigation;
/**
 *  The menu item that the rating is about
 */
@property(nonatomic, strong) MMMenuItem *menuItem;
/**
 *  The review information for the menu item
 */
@property(nonatomic, strong) MMMenuItemRating *menuItemReview;
/**
 *  Restaurant that the menu item belongs too.
 */
@property(nonatomic, strong) MMMerchant *selectedRestaurant;
/**
 *  Reference to the Rating Wheel popover controller for editing.
 */
@property(nonatomic, strong) MMRatingPopoverViewController *reviewPopOver;
/**
 *  Call back variable
 */
@property(nonatomic, copy) FinishCallback callback;

/**
 *  Reference kept for the current popover.
 */
@property(nonatomic, strong) UIPopoverController *popOverController;

/**
 *  Reference kept for the last popover.
 */
@property(nonatomic, strong) UIPopoverController *oldPopOverController;


/**
 *  Called when the SUbmit button is clicked
 *  @param sender
 */
- (IBAction)submitReview:(id)sender;
/**
 *  Called if the cancel button is clicked
 *  @param sender
 */
- (IBAction)cancelReview:(id)sender;
/**
 *  Called if the like button is clicked
 *  @param sender
 */
- (IBAction)likeReview:(id)sender;
/**
 *  Called if the report button is clicked
 *  @param sender
 */
- (IBAction)reportReview:(id)sender;
/**
 *  Called if the edit button is clicked.
 *  @param sender
 */
- (IBAction)editReview:(id)sender;
@end
