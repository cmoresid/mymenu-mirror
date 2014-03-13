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

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"
#import "MMreviewPopOverDelegate.h"
#import "MMRatingPopoverViewController.h"
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMBaseNavigationController.h"


@interface MMReviewPopOverViewController : UIViewController <UIPopoverControllerDelegate, MMDBFetcherDelegate>

@property(nonatomic, assign) CGFloat currentRating;
@property(nonatomic, weak) IBOutlet UILabel *restaurantName;
@property(nonatomic, weak) IBOutlet UILabel *menuItemName;
@property(nonatomic, weak) IBOutlet UIImageView *menuItemImage;
@property(nonatomic, weak) IBOutlet UITextView *desc;
@property(nonatomic, weak) IBOutlet UIButton *like;
@property(nonatomic, weak) IBOutlet UIButton *report;
@property(nonatomic, weak) IBOutlet UIButton *edit;
@property(nonatomic, weak) IBOutlet UILabel *likecount;
@property(nonatomic, weak) IBOutlet UIView *labelBack;
@property(nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property(nonatomic, strong) MMBaseNavigationController *popOverNavigation;
@property(nonatomic, strong) MMMenuItem *menuItem;
@property(nonatomic, strong) MMMerchant *selectedRestaurant;
@property(nonatomic) BOOL reviewSize;
@property(nonatomic, strong) id <MMReviewPopOverDelegate> delegate;
@property(nonatomic, strong) MMRatingPopoverViewController *reviewPopOver;

@property(nonatomic, strong) UIPopoverController *popOverController;
@property(nonatomic, strong) UIPopoverController *oldPopOverController;

- (IBAction)submitReview:(id)sender;

- (IBAction)cancelReview:(id)sender;

- (IBAction)likeReview:(id)sender;

- (IBAction)reportReview:(id)sender;

- (IBAction)editReview:(id)sender;
@end
