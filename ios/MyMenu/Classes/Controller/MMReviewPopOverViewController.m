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

#import "MMReviewPopOverViewController.h"
#import "MMMenuItemRating.h"
#import "MMDBFetcherDelegate.h"
#import "MMDBFetcher.h"
#import "MMLoginManager.h"
#import "MBProgressHUD.h"
#import "UIColor+MyMenuColors.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMRatingPopoverViewController.h"


#define kReview @"kReview"


@interface MMReviewPopOverViewController ()

@end

MMMenuItemRating *review;
MMUser *userprofile;
NSInteger ratingValue;

@implementation MMReviewPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    userprofile = [[MMUser alloc] init];
    userprofile = [[MMLoginManager sharedLoginManager] getLoggedInUser];

    [MMDBFetcher get].delegate = self;
    review = [[MMMenuItemRating alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveReview:)
                                                 name:kReview
                                               object:nil];
    _ratingLabel = (UILabel *) [self.view viewWithTag:100];
    _labelBack = (UIView *) [self.view viewWithTag:101];
}


- (void)didReceiveReview:(NSNotification *)notification {

    review = notification.object;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];

    NSString *rate = [formatter stringFromNumber:review.rating];

    _desc.text = review.review;
    _menuItemName.text = review.menuitemname;
    _restaurantName.text = review.merchantName;
    _likecount.text = [NSString stringWithFormat:@"%@", review.likeCount];
    _labelBack.backgroundColor = [UIColor lightBackgroundGray];
    _labelBack.layer.cornerRadius = 5;
    _ratingLabel.text = rate;
    _ratingLabel.userInteractionEnabled = NO;

    if (review.itemImage != nil && ![review.itemImage isEqualToString:@"null"]) {
        [self.menuItemImage setImageWithURL:[NSURL URLWithString:review.itemImage] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    }
    if (![review.useremail isEqualToString:userprofile.email]) {
        _edit.enabled = NO;
        [_edit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }

    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {

        _edit.enabled = NO;
        [_edit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _report.enabled = NO;
        [_report setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _like.enabled = NO;
        [_like setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    } else {
        [[MMDBFetcher get] userLiked:userprofile.email withReview:review.id];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }
}


- (void)didUserLike:(BOOL)exists withResponse:(MMDBFetcherResponse *)response {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;

    } else if (exists) {
        _like.enabled = NO;
        [_like setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    [[MMDBFetcher get] userReported:userprofile.email withReview:review.id];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

}

- (void)didUserReport:(BOOL)exists withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else if (exists) {
        _report.enabled = NO;
        [_report setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitReview:(id)sender {
    if (_ratingLabel.userInteractionEnabled) {
        review.review = _desc.text;
        review.rating = [NSNumber numberWithInteger:[_ratingLabel.text integerValue]];
        [[MMDBFetcher get] editReview:review];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }
}

- (void)didUpdateRatings:(BOOL)exists withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }
    else if (exists) {
        [self.delegate didSelectDone:YES];
    }

    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

}

- (IBAction)cancelReview:(id)sender {
    [self.delegate didSelectCancel:YES];

}

- (IBAction)likeReview:(id)sender {

    _like.enabled = NO;
    [_like setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    NSInteger likecount = [review.likeCount integerValue];
    _likecount.text = [NSString stringWithFormat:@"%d", likecount++];
    [[MMDBFetcher get] likeReview:userprofile.email withMenuItem:review.menuid withMerch:review.merchid withReview:review.id];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];


}

- (IBAction)reportReview:(id)sender {

    _report.enabled = NO;
    [_report setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [[MMDBFetcher get] reportReview:userprofile.email withMenuItem:review.menuid withMerch:review.merchid withReview:review.id];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

}

- (IBAction)editReview:(id)sender {
    _desc.editable = YES;
    _ratingLabel.userInteractionEnabled = YES;
    [_desc becomeFirstResponder];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];


    if (CGRectContainsPoint([_ratingLabel frame], [touch locationInView:_labelBack]) && _ratingLabel.userInteractionEnabled) {
        // Make sure keyboard is hidden before you show popup.
        [self.desc resignFirstResponder];

        MMRatingPopoverViewController *ratingPop = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuItemRatingPopover"];
        self.menuItem = [[MMMenuItem alloc] init];
        self.menuItem.itemid = review.menuid;
        self.menuItem.name = review.menuitemname;
        self.menuItem.picture = review.itemImage;
        self.selectedRestaurant = [[MMMerchant alloc] init];
        self.selectedRestaurant.businessname = review.merchantName;
        self.selectedRestaurant.mid = review.merchid;

        ratingPop.menuItem = self.menuItem;
        ratingPop.menuItemMerchant = self.selectedRestaurant;

        // Check if a rating has been previously selected. If one has
        // been, pre-select that value in the ratings wheel in the
        // popover.
        if (review.rating != nil || [review.rating intValue] > 0) {
            ratingPop.currentRating = [review.rating floatValue] / 10.0f;
        }

        ratingPop.selectedRating = ^(NSNumber *rating) {
            review.rating = rating;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
            [formatter setMaximumFractionDigits:1];
            [formatter setMinimumFractionDigits:1];

            NSString *rate = [formatter stringFromNumber:review.rating];
            self.ratingLabel.text = rate;

            ratingValue = [rating integerValue];
            [self.popOverController dismissPopoverAnimated:YES];
        };

        ratingPop.cancelRating = ^(NSNumber *rating) {
            [self.popOverController dismissPopoverAnimated:YES];
        };

        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:ratingPop];

        popover.popoverContentSize = CGSizeMake(500, 500);
        popover.delegate = self;

        self.popOverController = popover;

        [self.popOverController presentPopoverFromRect:self.ratingLabel.frame
                                                inView:self.ratingLabel.superview
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];

    }
}

- (void)didAddReviewLike:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response {

    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else if (!succesful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

}

- (void)didAddReviewReport:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response {

    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else if (!succesful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

}
@end
