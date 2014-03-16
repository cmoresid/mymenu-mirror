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

    userprofile = [[MMLoginManager sharedLoginManager] getLoggedInUser];

    [MMDBFetcher get].delegate = self;

    _ratingLabel = (UILabel *) [self.view viewWithTag:100];
    _labelBack = (UIView *) [self.view viewWithTag:101];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    
    NSString *rate = [formatter stringFromNumber:self.menuItemReview.rating];
    
    _desc.text = self.menuItemReview.review;
    _menuItemName.text = self.menuItemReview.menuitemname;
    _restaurantName.text = self.menuItemReview.merchantName;
    _likecount.text = [NSString stringWithFormat:@"%@", self.menuItemReview.likeCount];
    _labelBack.backgroundColor = [UIColor lightBackgroundGray];
    _labelBack.layer.cornerRadius = 5;
    _ratingLabel.text = rate;
    _ratingLabel.userInteractionEnabled = NO;
    
    if (self.menuItemReview.itemImage != nil && ![self.menuItemReview.itemImage isEqualToString:@"null"]) {
        [self.menuItemImage setImageWithURL:[NSURL URLWithString:self.menuItemReview.itemImage] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    }
    if (![self.menuItemReview.useremail isEqualToString:userprofile.email]) {
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
        [[MMDBFetcher get] userLiked:userprofile.email withReview:self.menuItemReview.id];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }

}
- (void)viewDidAppear:(BOOL)animated {
    self.oldPopOverController.popoverContentSize = CGSizeMake(500, 400);
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
    [[MMDBFetcher get] userReported:userprofile.email withReview:self.menuItemReview.id];
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
        self.menuItemReview.review = _desc.text;
        self.menuItemReview.rating = [NSNumber numberWithInteger:[_ratingLabel.text integerValue]];
        [[MMDBFetcher get] editReview:self.menuItemReview];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }
    
    self.callback(YES);
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
        self.callback(YES);
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
    self.callback(NO);
}

- (IBAction)likeReview:(id)sender {

    _like.enabled = NO;
    [_like setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    NSInteger likecount = [self.menuItemReview.likeCount integerValue];
    _likecount.text = [NSString stringWithFormat:@"%d", likecount++];
    [[MMDBFetcher get] likeReview:userprofile.email withMenuItem:self.menuItemReview.menuid withMerch:self.menuItemReview.merchid withReview:self.menuItemReview.id];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}

- (IBAction)reportReview:(id)sender {
    _report.enabled = NO;
    [_report setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [[MMDBFetcher get] reportReview:userprofile.email withMenuItem:self.menuItemReview.menuid withMerch:self.menuItemReview.merchid withReview:self.menuItemReview.id];
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
        self.menuItem.itemid = self.menuItemReview.menuid;
        self.menuItem.name = self.menuItemReview.menuitemname;
        self.menuItem.picture = self.menuItemReview.itemImage;
        self.selectedRestaurant = [[MMMerchant alloc] init];
        self.selectedRestaurant.businessname = self.menuItemReview.merchantName;
        self.selectedRestaurant.mid = self.menuItemReview.merchid;

        ratingPop.menuItem = self.menuItem;
        ratingPop.menuItemMerchant = self.selectedRestaurant;
        ratingPop.oldView = self.view;

        // Check if a rating has been previously selected. If one has
        // been, pre-select that value in the ratings wheel in the
        // popover.
        if (self.menuItemReview.rating != nil || [self.menuItemReview.rating intValue] > 0) {
            ratingPop.currentRating = [self.menuItemReview.rating floatValue] / 10.0f;
        }

        ratingPop.selectedRating = ^(NSNumber *rating) {
            self.menuItemReview.rating = rating;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
            [formatter setMaximumFractionDigits:1];
            [formatter setMinimumFractionDigits:1];

            NSString *rate = [formatter stringFromNumber:self.menuItemReview.rating];
            self.ratingLabel.text = rate;

            ratingValue = [rating integerValue];
            self.edit.enabled = NO;
            [self.desc becomeFirstResponder];
            [self.navigationController setNavigationBarHidden:YES];
            [self.popOverController dismissPopoverAnimated:YES];
        };

        ratingPop.cancelRating = ^(NSNumber *rating) {
            [self.popOverController dismissPopoverAnimated:YES];
        };
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:ratingPop animated:YES];
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
    [self.navigationController setNavigationBarHidden:YES];

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
