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

#import <UIKit/UIKit.h>
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMRestaurantPopOverDelegate.h"
#import "MMReviewPopOverDelegate.h"
#import "MMReviewPopOverViewController.h"

@class MMRestaurantPopOverViewController;
@class HMSegmentedControl;

/** The restaurant view controller.
 This displays a single restaurant in detail.
 Information such as restaurant name, rating, description, etc.
 This is where the restaurant's menu is displayed.
 This view will also allow the user to filter through the menu,
 either by rating, category or name.
*/
@interface MMRestaurantViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MMDBFetcherDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, MMRestaurantPopOverDelegate, MMReviewPopOverDelegate>


/**
 *  The current selected merchant.
 */
@property MMMerchant *currentMerchant;

/**
 *  The UILabel for the mechant name
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantNameLabel; // restaurant name
/**
 *  The UILabel for the merchant phone number
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantPhoneNumberLabel; // restaurant phone number
/**
 *  The UILabel for the merchant rating
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantRatingLabel; // restaurant rating
/**
 *  The UITextView for the merchant description
 */
@property(nonatomic, weak) IBOutlet UITextView *merchantDescriptionTextView; // restaurant description
/**
 *  The UIImageView for the merchant image
 */
@property(nonatomic, weak) IBOutlet UIImageView *merchantImageView; // restaurant image

/**
 *  The UIView for the merchant rating
 */
@property(nonatomic, weak) IBOutlet UIView *ratingView; // rounded background for restaurant rating

/**
 *  The UISearchBar for searching menu items
 */
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar; // field for search by name

/**
 *  The UIButton to filter by category
 */
@property(nonatomic, weak) IBOutlet UIButton *categoryButton; // filter by category buttton

@property(nonatomic, weak) IBOutlet HMSegmentedControl *categorySegment;

/**
 *  UICollectionView that displays the menu items
 */
@property(nonatomic, weak) IBOutlet UICollectionView *menuItemsCollectionView; // the menu collection

/**
 *  UINavigationBar at the top of the Screen
 */
@property(nonatomic, weak) IBOutlet UINavigationBar *navigationBar;//the navigation bar at the top of the screen

/**
 *  The UICollectionView for reviews
 */
@property(nonatomic, weak) IBOutlet UICollectionView *reviewsCollectionView; //review collection view

/**
 *  The UISegmentedControl for filtering reviews
 */
@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl; //review segemented control

/**
 *  Merchant Hours Label
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantHoursLabel;

/**
 *  Merchant Address Label
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantAddressLabel;

/**
 *  Popover View Controller
 */
@property(nonatomic, strong) UIPopoverController *popOverController;

/**
 *  View Controller that gets displayed inside of a popover.
 */
@property(nonatomic, strong) MMRestaurantPopOverViewController *restPopOver;
@property(nonatomic, strong) MMReviewPopOverViewController *revPopOver;

/**
 *  Clear category filter button
 *
 *  @param sender UIButton
 */
- (IBAction)categoryClear:(id)sender;

/**
 *  Clear the search bar button
 *
 *  @param sender UIButton
 */
- (IBAction)searchClear:(id)sender;

/**
 *  Which category was selected, and filter
 *
 *  @param sender UIPickerView
 */
- (IBAction)categoryPicker:(id)sender;

/**
 *  Return to main screen button
 *
 *  @param sender UIButton
 */
- (IBAction)cancelToMainScreen:(id)sender;

@end

