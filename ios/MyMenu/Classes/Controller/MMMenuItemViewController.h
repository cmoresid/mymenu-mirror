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
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"

@class MMReviewPopOverViewController;

/**
 *  The controller that shows the selected menu item a user selects.
 */
@interface MMMenuItemViewController : UITableViewController <UITableViewDataSource, MMDBFetcherDelegate, UITextViewDelegate, UIPopoverControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

/**
 *  The item that the user touched before
 */
@property MMMenuItem *currentMenuItem;

/**
 *  The current mechant of the menu item
 */
@property MMMerchant *currentMerchant;
/**
 *
 */
@property BOOL reviewViewFlag;

/**
 *  Popover view controller
 */
@property(nonatomic, strong) UIPopoverController *popOverController;

/**
 *  The label for the item name
 */
@property(nonatomic, weak) IBOutlet UILabel *itemName;

/**
 *  The input review textview for a user submitted review.
 */
@property(nonatomic, weak) IBOutlet UITextView *userReviewField;

/**
 *  Current Selected Text View
 */
@property(nonatomic, weak) IBOutlet UITextView *activeField;

/**
 *  The Items Rating Label
 */
@property(nonatomic, weak) IBOutlet UILabel *itemRating;
/**
 *
 */
@property (nonatomic, weak) IBOutlet UIView * reviewView;

/**
 *  The menu items description
 */
@property(nonatomic, weak) IBOutlet UITextView *itemDescription;

/**
 *  The menu items description
 */
@property(nonatomic, weak) IBOutlet UIImageView *itemImage;

/**
 *  The menu items rating
 */
@property(nonatomic, weak) IBOutlet UIView *itemRatingView;

/**
 *  The tablview that holds the avaliable Restrictions for the menu item
 */
@property(nonatomic, weak) IBOutlet UITextView *menuModificationsView;

/**
 *  Rate button
 */
@property(nonatomic, weak) IBOutlet UIButton *ratingButton;

/**
 *  I've eaten this button
 */
@property(nonatomic, weak) IBOutlet UIButton *eatenThisButton;

/**
 *  Current Rating of menu Item
 */
@property(nonatomic, strong) NSNumber *rating;

@property(nonatomic, strong) MMReviewPopOverViewController *reviewPopOver;

/**
 *  Menu Item View for showing reviews.
 */
@property(nonatomic, weak) IBOutlet UICollectionView *ratingsCollectionView;

/**
 *  Switch the ratings view to show top rated first or most recent
 */
@property(nonatomic, strong) UISegmentedControl *reviewSegment;

/**
 *  Current Orientation of the device.
 *
 */
@property(nonatomic) UIDeviceOrientation currentOrientation;

/**
 *  Share the menu item via Social Media
 *
 *  @param sender UIButton
 */
- (IBAction)shareMenuItem:(id)sender;

/**
 *  Rate the menu item button selected
 *
 *  @param sender UIButton
 */
- (IBAction)rateItem:(id)sender;

/**
 *  Save the Rating the user inputed
 *
 *  @param sender UIButton
 */
- (IBAction)saveButton:(id)sender;

/**
 *  Clear the rating field, and current set rating (From the circle view)
 *
 *  @param sender UIButton
 */
- (IBAction)clearButton:(id)sender;

/**
 *  Current user has eaten the menu item.
 *
 *  @param sender UIButton
 */
- (IBAction)iveEatenThis:(id)sender;



@end
