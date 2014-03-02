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
    self.restaurantName.text = self.menuRestaurant.businessname;
    
    [self.menuItemImage setImageWithURL:[NSURL URLWithString:self.menuItem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.ratingView) {
        
        // TODO: Actually make the touch work properly. Was just copying
        // Mark's code to some extent. Doesn't quite work 100% here.
        
        CGPoint touchLocation = [touch locationInView:self.ratingView];
        
        double angleRadians = fabs(atan2(touchLocation.y, touchLocation.x) - atan2(-250.0, 0));
        
        if (angleRadians > 0.5 * M_PI)
            angleRadians = M_PI - angleRadians;
        
        double degrees = angleRadians * (180.0 / M_PI);
        
        if (touchLocation.x >= 0 && touchLocation.y >= 0) {
            degrees = degrees + 180.0;
        }
        else if (touchLocation.x >= 0) {
            degrees = 270.0 + (90.0 - fabs(degrees));
        }
        else if (touchLocation.y >= 0) {
            degrees = 90.0 + (90.0 - fabs(degrees));
        }
        
        double percentageOfCircle = (1 - (degrees / 360.0));
        
        self.ratingView.wheelPercentage = percentageOfCircle;
    }
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
