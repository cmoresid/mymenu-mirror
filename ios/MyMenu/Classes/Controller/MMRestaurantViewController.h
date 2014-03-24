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
#import "MMDBFetcherDelegate.h"
#import "MMReviewPopOverViewController.h"

@class MMRestaurantViewModel;
@class HMSegmentedControl;
@class MMMerchant;

/** 
 *  The restaurant view controller.
 *  This displays a single restaurant in detail.
 *  Information such as restaurant name, rating, description, etc.
 *  This is where the restaurant's menu is displayed.
 *  This view will also allow the user to filter through the menu,
 *  either by rating, category or name.
*/
@interface MMRestaurantViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIPopoverControllerDelegate,
    UIGestureRecognizerDelegate>

/**
 *  The current selected merchant.
 */
@property(nonatomic, strong) NSNumber *currentMerchantId;

/**
 *  The view model for the controller.
 */
@property(nonatomic, strong) MMRestaurantViewModel *viewModel;

/**
 *  The UILabel for the mechant name
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantNameLabel;

/**
 *  The UILabel for the merchant phone number
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantPhoneNumberLabel;

/**
 *  The UILabel for the merchant rating
 */
@property(nonatomic, weak) IBOutlet UILabel *merchantRatingLabel;

/**
 *  The UITextView for the merchant description
 */
@property(nonatomic, weak) IBOutlet UITextView *merchantDescriptionTextView;

/**
 *  The UIImageView for the merchant image
 */
@property(nonatomic, weak) IBOutlet UIImageView *merchantImageView;

/**
 *  The view that contains the merchant information
 *  on the top left of the screen. It also is responsible
 *  for drawing the grey border as well.
 */
@property(nonatomic, weak) IBOutlet UIView *merchantInformationContainer;

/**
 *  The rounded background for restaurant rating
 */
@property(nonatomic, weak) IBOutlet UIView *ratingView;

/**
 *  UICollectionView that displays the menu items
 */
@property(nonatomic, weak) IBOutlet UICollectionView *menuItemsCollectionView;

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
 *  The search bar that is inside the collection
 *  view. Allows one to filter through the menu
 *  items on the page.
 */
@property(nonatomic, strong) UISearchBar *searchBar;

/**
 *  The segment control that allows one to order
 *  the reviews in the collection view.
 */
@property(nonatomic, strong) UISegmentedControl *reviewOrderBySegmentControl;

/**
 *  The scroll view that encapsulates the views on
 *  the page.
 */
@property(nonatomic, weak) IBOutlet UIScrollView *parentScrollView;

/**
 *  View Controller that gets displayed inside of a popover.
 */
@property(nonatomic, strong) MMReviewPopOverViewController *revPopOver;

@end

