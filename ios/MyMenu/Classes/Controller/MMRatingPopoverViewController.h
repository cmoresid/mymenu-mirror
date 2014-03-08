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

- (void)moveRatingWheelWithTouch:(CGPoint)touchLocation;

@end
