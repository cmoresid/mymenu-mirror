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
