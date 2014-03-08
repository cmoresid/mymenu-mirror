//
//  MMRatingPopoverViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 3/1/2014.
//
//

#import "MMRatingPopoverViewController.h"
#import "MMRatingView.h"
#import "MMMenuItem.h"
#import "MMMerchant.h"
#import "UIColor+MyMenuColors.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MMRatingPopoverViewController ()

@end

@implementation MMRatingPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ratingView.wheelPercentage =
        (self.currentRating > 0.0f) ? self.currentRating : 0.1f;
	self.ratingView.wheelBackgroundColor = [UIColor lightBackgroundGray];
    self.ratingView.wheelFillColor = [UIColor lightTealColor];
    self.ratingView.multipleTouchEnabled = FALSE;
    
    self.menuItemName.text = self.menuItem.name;
    self.merchantName.text = self.menuItemMerchant.businessname;
    
    if (self.menuItem.picture != nil && ![self.menuItem.picture isEqualToString:@"null"]) {
        [self.menuItemImage setImageWithURL:[NSURL URLWithString:self.menuItem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.ratingView) {
        CGPoint touchLocation = [touch locationInView:self.ratingView];
        
        [self moveRatingWheelWithTouch:touchLocation];
    }
}

/*
 * Adaptation of Mark's code for the phone app.
 */
- (void)moveRatingWheelWithTouch:(CGPoint)touchLocation {
    float centerX = CGRectGetMidX(self.ratingView.bounds);
    float centerY = CGRectGetMidY(self.ratingView.bounds);
    
    float deltaX = touchLocation.x - centerX;
    float deltaY = touchLocation.y - centerY;

    double angleRadians = atan(deltaX / deltaY);
    
    if (angleRadians > M_PI_2)
        angleRadians = M_PI - angleRadians;
    
    double degrees = angleRadians * (180.0 / M_PI);
    
    // Check which quadrant the touch occured in and adjust
    // the angle appropriately.
    if (touchLocation.x >= centerX && touchLocation.y >= centerY) {
        degrees = degrees + 180.0;
    }
    else if (touchLocation.x >= centerX) {
        degrees = 270.0 + (90.0 - fabs(degrees));
    }
    else if (touchLocation.y >= centerY) {
        degrees = 90.0 + (90.0 - fabs(degrees));
    }
    
    double percentageOfCircle = (1 - (degrees / 360.0));
    
    self.ratingView.wheelPercentage = percentageOfCircle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitReview:(id)sender {
    self.selectedRating(self.ratingView.rating);
}

- (void)cancelReview:(id)sender {
    self.cancelRating(nil);
}

@end
