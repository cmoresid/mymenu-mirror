//
//  MMRatingPopoverViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 3/1/2014.
//
//

#import <UIKit/UIKit.h>

@class MMRatingView;
@class MMMenuItem;
@class MMMerchant;

typedef void (^RatingsReturnBlock)(NSNumber*);

/**
 *  The rating popover which shows the circle rating.
 */
@interface MMRatingPopoverViewController : UIViewController

/**
 *  The Rating view
 */
@property (nonatomic, weak) IBOutlet MMRatingView *ratingView;

/**
 *  The current rating
 */
@property (nonatomic, assign) CGFloat currentRating;

/**
 *  Label to show restaurnt who the menu item belongs to
 */
@property (nonatomic, weak) IBOutlet UILabel *merchantName;

/**
 *  The Menu item which is being rated
 */
@property (nonatomic, weak) IBOutlet UILabel *menuItemName;

/**
 *  A picture of the menu item view
 */
@property (nonatomic, weak) IBOutlet UIImageView *menuItemImage;

/**
 *  The current menu item
 */
@property (nonatomic, strong) MMMenuItem *menuItem;

/**
 *  The Current menu item merchant
 */
@property (nonatomic, strong) MMMerchant *menuItemMerchant;

/**
 *  The rating the user selected.
 */
@property (nonatomic, copy) RatingsReturnBlock selectedRating;

/**
 *  Close the rating box, and return nothing.
 */
@property (nonatomic, copy) RatingsReturnBlock cancelRating;


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

@end
