//
//  MMReviewPopOverViewController.h
//  MyMenu
//
//  Created by Chris Moulds on 2014-03-06.
//
//

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"
#import "MMreviewPopOverDelegate.h"
#import "MMRatingPopoverViewController.h"
#import "MMMerchant.h"


@interface MMReviewPopOverViewController : UIViewController <UIPopoverControllerDelegate>

@property (nonatomic, assign) CGFloat currentRating;
@property (nonatomic, weak) IBOutlet UILabel *restaurantName;
@property (nonatomic, weak) IBOutlet UILabel *menuItemName;
@property (nonatomic, weak) IBOutlet UIImageView *menuItemImage;
@property (nonatomic, weak) IBOutlet UITextView *desc;
@property (nonatomic, weak) IBOutlet UIButton *like;
@property (nonatomic, weak) IBOutlet UIButton *report;
@property (nonatomic, weak) IBOutlet UIButton *edit;
@property (nonatomic, weak) IBOutlet UILabel *likecount;
@property (nonatomic, weak) IBOutlet UIView *labelBack;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) MMMenuItem *menuItem;
@property (nonatomic, strong) MMMerchant *selectedRestaurant;
@property (nonatomic, strong) id <MMReviewPopOverDelegate> delegate;
@property (nonatomic, strong) MMRatingPopoverViewController *reviewPopOver;

@property (nonatomic, strong) UIPopoverController * popOverController;




- (IBAction)submitReview:(id)sender;
- (IBAction)cancelReview:(id)sender;
- (IBAction)likeReview:(id)sender;
- (IBAction)reportReview:(id)sender;
- (IBAction)editReview:(id)sender;
@end
