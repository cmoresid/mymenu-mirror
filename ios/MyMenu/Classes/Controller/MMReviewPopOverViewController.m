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
#import "SDWebImage/UIImageView+WebCache.h"

#define kReview @"kReview"


@interface MMReviewPopOverViewController ()

@end

MMMenuItemRating *review;
MMUser* userprofile;

@implementation MMReviewPopOverViewController

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
    
    
    userprofile = [[MMUser alloc] init];
    
    userprofile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    [MMDBFetcher get].delegate = self;
    
    
    
    review = [[MMMenuItemRating alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveReview:)
                                                 name:kReview
                                               object:nil];
}


- (void) didReceiveReview: (NSNotification*) notification{

    review = notification.object;
    
    _desc.text = review.review;
    _menuItemName.text = review.menuitemname;
    _restaurantName.text = review.merchantName;
    _likecount.text = [NSString stringWithFormat:@"%@", review.likeCount];
    if (review.itemImage != nil && ![review.itemImage isEqualToString:@"null"]) {
        [self.menuItemImage setImageWithURL:[NSURL URLWithString:review.itemImage] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitReview:(id)sender{
    
    
    
}
- (IBAction)cancelReview:(id)sender{
    
}
- (IBAction)likeReview:(id)sender{
    
    [[MMDBFetcher get] likeReview:userprofile.email withMenuItem:review.menuid withMerch:review.merchid withReview:review.id];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    
    
}
- (IBAction)reportReview:(id)sender{
    
}
- (IBAction)editReview:(id)sender{
    
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
    }
    
}
@end
