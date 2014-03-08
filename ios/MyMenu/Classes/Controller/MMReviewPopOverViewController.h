//
//  MMReviewPopOverViewController.h
//  MyMenu
//
//  Created by Chris Moulds on 2014-03-06.
//
//

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"


@interface MMReviewPopOverViewController : UIViewController

@property (nonatomic, assign) CGFloat currentRating;
@property (nonatomic, weak) IBOutlet UILabel *restaurantName;
@property (nonatomic, weak) IBOutlet UILabel *menuItemName;
@property (nonatomic, weak) IBOutlet UIImageView *menuItemImage;
@property (nonatomic, weak) IBOutlet UITextView *desc;
@property (nonatomic, weak) IBOutlet UIButton *like;
@property (nonatomic, weak) IBOutlet UIButton *report;
@property (nonatomic, weak) IBOutlet UIButton *edit;
@property (nonatomic, weak) IBOutlet UILabel *likecount;
@property (nonatomic, strong) MMMenuItem *menuItem;



- (IBAction)submitReview:(id)sender;
- (IBAction)cancelReview:(id)sender;
- (IBAction)likeReview:(id)sender;
- (IBAction)reportReview:(id)sender;
- (IBAction)editReview:(id)sender;
@end
