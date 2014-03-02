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

@interface MMRatingPopoverViewController : UIViewController

@property (nonatomic, weak) IBOutlet MMRatingView *ratingView;
@property (nonatomic, assign) CGFloat currentRating;
@property (nonatomic, weak) IBOutlet UILabel *restaurantName;
@property (nonatomic, weak) IBOutlet UILabel *menuItemName;
@property (nonatomic, weak) IBOutlet UIImageView *menuItemImage;
@property (nonatomic, strong) MMMenuItem *menuItem;
@property (nonatomic, strong) MMMerchant *menuRestaurant;
@property (nonatomic, copy) RatingsReturnBlock selectedRating;
@property (nonatomic, copy) RatingsReturnBlock cancelRating;

- (IBAction)submitReview:(id)sender;
- (IBAction)cancelReview:(id)sender;

@end
