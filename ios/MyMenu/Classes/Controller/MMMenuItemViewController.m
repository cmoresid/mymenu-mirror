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

#import "MMMenuItemViewController.h"
#import "UIColor+MyMenuColors.h"
#import "MMRestaurantViewController.h"
#import "MMMerchant.h"
#import "MMSocialMediaService.h"
#import <Social/Social.h>
#import "MMDBFetcher.h"
#import "MMUser.h"
#import "MBProgressHUD.h"
#import "MMRatingPopoverViewController.h"
#import "MMMenuItemRating.h"
#import "MMMenuItemReviewCell.h"
#import "MMLoginManager.h"
#import "MMMenuItemReviewCell.h"
#import "MMReviewPopOverViewController.h"
#import "MMPresentationFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MMMenuItemCollectionViewFlowLayout.h"

#define kCondensedTopReviews @"condensedTopReviews"
#define kCondensedRecentReviews @"condensedRecentReviews"
#define kAllRecentReviews @"allRecentReviews"
#define kAllTopReviews @"allTopReviews"
#define kReview @"kReview"


@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController


NSMutableArray *mods;
NSInteger ratingValue;
MMUser *userProfile;
NSMutableArray *condensedReviews;
NSMutableArray *allReviews;
NSMutableDictionary *reviewDictionary;
MMMenuItemRating *touchedItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    userProfile = [[MMUser alloc] init];
//    reviewDictionary = [[NSMutableDictionary alloc] init];
//    // Do any additional setup after loading the view.
//    mods = [[NSMutableArray alloc] init];
//    self.rating = nil;
//    self.userReviewField.delegate = self;
//    self.ratingsCollectionView.delegate = self;
//    self.ratingsCollectionView.dataSource = self;
//    // Register for keyboard notifications to allow
//    // for view to scroll to text field
    [self configureView];
//    [[self.userReviewField layer] setBorderColor:[[UIColor tealColor] CGColor]];
//    [[self.userReviewField layer] setBorderWidth:2.3];
//    [[self.userReviewField layer] setCornerRadius:5];
//    [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.ratingButton setTitle:@"Rate This Item" forState:UIControlStateNormal];
//    _itemName.text = _currentMenuItem.name;
//    _itemDescription.text = _currentMenuItem.desc;
//    [_itemDescription setTextColor:[UIColor blackColor]];
//    [_itemDescription setFont:[UIFont systemFontOfSize:19.0]];
//    _itemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_currentMenuItem.picture]]];
//    _itemRating.text = [MMPresentationFormatter formatRatingForRawRating:_currentMenuItem.rating];
//    _itemRatingView.backgroundColor = [UIColor lightBackgroundGray];
//    _itemRatingView.layer.cornerRadius = 17.5;
//    self.menuModificationsTableView.dataSource = self;
    userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getModifications:_currentMenuItem.itemid withUser:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self.ratingsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
//    [self.reviewSegment addTarget:self
//                           action:@selector(changeReviewSort:)
//                 forControlEvents:UIControlEventValueChanged];
//    [self.menuModificationsTableView reloadData];
    [self.ratingsCollectionView reloadData];
//
//    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
//        _eatenThisButton.hidden = YES;
//    }else{
//        _eatenThisButton.hidden = NO;
//        _eatenThisButton.enabled = YES;
//        _eatenThisButton.backgroundColor = [UIColor lightTealColor];
//        [[MMDBFetcher get] userEaten:userProfile.email withItem:_currentMenuItem.itemid];
//        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
//    }

}

- (void)configureView {
    self.itemName.text = self.currentMenuItem.name;
    self.itemRating.text = [MMPresentationFormatter formatRatingForRawRating:_currentMenuItem.rating];
    self.itemDescription.text = self.currentMenuItem.desc;
    self.itemDescription.font = [UIFont systemFontOfSize:18.0];
    self.itemRatingView.layer.cornerRadius = 17.5;
    [self.itemImage setImageWithURL:[NSURL URLWithString:_currentMenuItem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    
    self.ratingsCollectionView.delegate = self;
    self.ratingsCollectionView.dataSource = self;
    [self.ratingsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
    /*[self.reviewSegment addTarget:self
     action:@selector(changeReviewSort:)
     forControlEvents:UIControlEventValueChanged];
     //[self.menuModificationsTableView reloadData];
     [self.ratingsCollectionView reloadData];*/
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.row == 0 && indexPath.section == 0) {
        
		static NSString *CellIdentifier = @"menuitem";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		NSString *itemName = self.currentMenuItem.name;
		
		UITextView *nameView = (UITextView *) [cell viewWithTag:1];
		nameView.text = itemName;
		
		UIView *labelBack = (UIView *) [cell viewWithTag:2];
		labelBack.backgroundColor = [UIColor lightBackgroundGray];
        labelBack.layer.cornerRadius = 17.5;
		
		UILabel *ratingView = (UILabel *) [cell viewWithTag:3];
		ratingView.text = [MMPresentationFormatter formatRatingForRawRating:_currentMenuItem.rating];
		
		UITextView *descriptionTextView = (UITextView *) [cell viewWithTag:5];
		descriptionTextView.text = self.currentMenuItem.desc;
		
		UIImageView * itemImage = (UIImageView *) [cell viewWithTag:4];
		itemImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_currentMenuItem.picture]]];
		
		//    _itemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_currentMenuItem.picture]]];
		return cell;
        
	} else if(indexPath.section == 1) {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		NSString *modification = [mods objectAtIndex:indexPath.row];
		
		UITextView *modificationView = (UITextView *) [cell viewWithTag:500];
		modificationView.text = modification;
		
		return cell;
	} else if(indexPath.row == 0 && indexPath.section == 2) {
		
		static NSString *CellIdentifier = @"rateitem";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
		return cell;
	} else if(indexPath.section == 3) {
		
		static NSString *CellIdentifier = @"collectionview";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		UICollectionView *collectionView = (UICollectionView *) [cell viewWithTag:66];
		
		if(!self.ratingsCollectionView) {
            self.ratingsCollectionView = collectionView;
			self.ratingsCollectionView.delegate = self;
			self.ratingsCollectionView.dataSource = self;
            [self.ratingsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
            [self.reviewSegment addTarget:self
             action:@selector(changeReviewSort:)
             forControlEvents:UIControlEventValueChanged];
             //[self.menuModificationsTableView reloadData];
            [self.ratingsCollectionView reloadData];
            
            
            //NSLog(@"COLLECTIONVIEW: X: %f",self.ratingsCollectionView.setNeedsDisplay);
		}
		//[self.ratingsCollectionView setNeedsDisplay];
		return cell;
	}
	else {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		NSString *modification = [mods objectAtIndex:indexPath.row-3];
		
		UITextView *modificationView = (UITextView *) [cell viewWithTag:500];
		[modificationView setFont:[UIFont systemFontOfSize:30.0]];
		modificationView.text = modification;
		
		return cell;
	}
}*/

- (void)didRetrieveTopItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    MMMenuItemRating *rating = [[MMMenuItemRating alloc] init];
    condensedReviews = [[NSMutableArray alloc] init];
    allReviews = [[NSMutableArray alloc] init];
    rating.useremail = @"See More Reviews";
    rating.id = [NSNumber numberWithInt:-1];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else {
        if (ratings.count != 0) {
            allReviews = [ratings mutableCopy];
            if (ratings.count >= 4) {
                for (NSInteger w = 0; w <= 2; w++) {
                    [condensedReviews addObject:[ratings objectAtIndex:w]];
                }
                [condensedReviews addObject:rating];
            } else {
                condensedReviews = [ratings mutableCopy];
                [condensedReviews addObject:rating];
            }
        } else {
            rating.review = @"There are not any reviews available for this dish.";
            [condensedReviews addObject:rating];
            [allReviews addObject:rating];
        }
        [reviewDictionary setObject:allReviews forKey:kAllTopReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedTopReviews];
        if (self.reviewViewFlag) {
            condensedReviews = [reviewDictionary objectForKey:kAllTopReviews];
        }
        [self.ratingsCollectionView reloadData];
    }

}

- (void)didRetrieveRecentItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    MMMenuItemRating *rating = [[MMMenuItemRating alloc] init];
    rating.useremail = @"See More Reviews";
    rating.id = [NSNumber numberWithInt:-1];
    allReviews = [[NSMutableArray alloc] init];
    condensedReviews = [[NSMutableArray alloc] init];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else {
        if (ratings.count != 0) {
            allReviews = [ratings mutableCopy];
            if (ratings.count >= 4) {
                for (NSInteger w = 0; w <= 2; w++) {
                    [condensedReviews addObject:[ratings objectAtIndex:w]];
                }
                [condensedReviews addObject:rating];
            } else {
                condensedReviews = [ratings mutableCopy];
                [condensedReviews addObject:rating];
            }
        } else {
            rating.review = @"There are not any reviews available for this dish.";
            [condensedReviews addObject:rating];
            [allReviews addObject:rating];
        }
        [reviewDictionary setObject:allReviews forKey:kAllRecentReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedRecentReviews];
        if (self.reviewViewFlag) {
            condensedReviews = [reviewDictionary objectForKey:kAllRecentReviews];
        }
        [self.ratingsCollectionView reloadData];
    }

}

- (void)didRetrieveModifications:(NSArray *)modificationsArray withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else {
        if (modificationsArray.count != 0) {
            mods = [modificationsArray mutableCopy];
        } else {
            [mods addObject:@"There are not any modifications available for this dish."];
        }
        [[MMDBFetcher get] getItemRatings:_currentMenuItem.itemid];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self.menuModificationsTableView reloadData];
    }
}




#pragma mark - Table View

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return FALSE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"backToRestPage"]) {
        //MMRestaurantViewController *restaurantController = [segue destinationViewController];
        //restaurantController.currentMerchant = _currentMerchant;

    }
}

- (IBAction)shareViaFacebook:(id)sender {
    SLComposeViewController *controller = [MMSocialMediaService shareMenuItem:self.currentMenuItem withService:SLServiceTypeFacebook];

    if (controller) {
        [self presentViewController:controller animated:TRUE completion:nil];
    }
}

- (IBAction)shareViaTwitter:(id)sender {
    SLComposeViewController *controller = [MMSocialMediaService shareMenuItem:self.currentMenuItem withService:SLServiceTypeTwitter];

    if (controller) {
        [self presentViewController:controller animated:TRUE completion:nil];
    }
}

- (IBAction)rateItem:(id)sender {
    MMRatingPopoverViewController *ratingPop = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuItemRatingPopover"];

    ratingPop.menuItem = self.currentMenuItem;
    ratingPop.menuItemMerchant = self.currentMerchant;

    // Check if a rating has been previously selected. If one has
    // been, pre-select that value in the ratings wheel in the
    // popover.
    if (self.rating != nil || [self.rating intValue] > 0) {
        ratingPop.currentRating = [self.rating floatValue] / 10.0f;
    }

    ratingPop.selectedRating = ^(NSNumber *rating) {
        self.rating = rating;
        [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Your Rating: %d", [rating integerValue]] forState:UIControlStateNormal];
        [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

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

    // Make sure keyboard is hidden before you show popup.
    [self.userReviewField resignFirstResponder];

    [self.popOverController presentPopoverFromRect:self.ratingButton.frame
                                            inView:self.ratingButton.superview
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];

}


- (void)didCreateRating:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
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
    if (successful == FALSE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Your Review did not send.  Please check your internet connection and try again."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else {
        self.userReviewField.text = @"Please enter your review here...";
        [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Rate This Item"] forState:UIControlStateNormal];
        [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return condensedReviews.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        static NSString *cellIdentifyer = @"CellHeader";
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifyer forIndexPath:indexPath];
        
        self.reviewSegment = (UISegmentedControl *) [headerView viewWithTag:500];
        [self.reviewSegment addTarget:self
                               action:@selector(changeReviewSort:)
                     forControlEvents:UIControlEventValueChanged];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    MMMenuItemReviewCell *itemCell = (MMMenuItemReviewCell *) cell;
    touchedItem = [[MMMenuItemRating alloc] init];
    touchedItem = itemCell.rating;
    if (touchedItem.id == [NSNumber numberWithInt:-1]){
        self.reviewViewFlag = YES;
        [UIView animateWithDuration:0.5f animations:^(void) {
            CGRect newFrame = CGRectMake(self.reviewView.frame.origin.x, self.reviewView.frame.origin.y - 275, self.reviewView.frame.size.width, self.reviewView.frame.size.height + 500);
            self.reviewView.frame = newFrame;
            
            CGRect newFrameCollectionView = CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y, collectionView.frame.size.width, collectionView.frame.size.height + 500);
            collectionView.frame = newFrameCollectionView;
        }];
        [self changeReviewSort:self.reviewSegment];
    }else{
        MMBaseNavigationController *reviewNavPop = [self.storyboard instantiateViewControllerWithIdentifier:@"popOverNavigation"];
        
        MMReviewPopOverViewController *reviewPop = [reviewNavPop.viewControllers firstObject];
        
        reviewPop.callback = ^(BOOL done) {
            [MMDBFetcher get].delegate = self;
            [self.popOverController dismissPopoverAnimated:YES];
        };
        
        reviewPop.menuItemReview = touchedItem;
        reviewPop.selectedRestaurant = _currentMerchant;
        reviewPop.reviewSize = self.reviewViewFlag;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:reviewNavPop];
        
        popover.delegate = self;
        reviewPop.oldPopOverController = popover;
        
        popover.delegate = self;
        
        self.popOverController = popover;
        
        // Make sure keyboard is hidden before you show popup.
        [self.userReviewField resignFirstResponder];
        
        [self.popOverController presentPopoverFromRect:cell.frame
                                                inView:cell.superview
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    }
    
}

- (void)didUserEat:(BOOL)exists withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    } else if (exists){
        _eatenThisButton.enabled = NO;
        _eatenThisButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        _eatenThisButton.enabled = YES;
        _eatenThisButton.backgroundColor = [UIColor lightTealColor];
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ReviewCell";

    MMMenuItemReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //cell.userInteractionEnabled = YES;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemReviewCell" owner:self options:NULL] objectAtIndex:0];
    }


    MMMenuItemRating *menitem = [condensedReviews objectAtIndex:indexPath.row];
    UILabel *textReview = (UILabel *) [cell viewWithTag:102];
    UILabel *textName = (UILabel *) [cell viewWithTag:101];
    UILabel *likeLabel = (UILabel *) [cell viewWithTag:108];
    UIView *labelBack = (UIView *) [cell viewWithTag:106];
    UIImageView *likeImage = (UIImageView *) [cell viewWithTag:107];
    UIImage *image = [UIImage imageNamed:@"upvote"];

    if (menitem.id == [NSNumber numberWithInt:-1]) {
        textName.text = @"See More Reviews";
        likeLabel.text = @"";
        textReview.text = @"";
        labelBack.backgroundColor = [UIColor whiteColor];
        likeImage.hidden = YES;
    } else {
        // Rounded Corners
        likeImage.hidden = NO;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.cornerRadius = 5;
        cell.contentView.layer.masksToBounds = YES;
        UILabel *textRating = (UILabel *) [cell viewWithTag:104];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        likeLabel.text = [NSString stringWithFormat:@"%@", menitem.likeCount];
        labelBack.backgroundColor = [UIColor lightBackgroundGray];
        labelBack.layer.cornerRadius = 5;
        textRating.text = [formatter stringFromNumber:menitem.rating];
        textName.text = [NSString stringWithFormat:@"%@ %@", menitem.firstname, menitem.lastname];
        [textReview setText:menitem.review];
        likeImage.image = image;
    }
    cell.rating = menitem;
    return cell;
}

- (void)changeReviewSort:(UISegmentedControl *)control {
    NSMutableArray *reviews;
    
    switch ([control selectedSegmentIndex]) {
        case 0:
            reviews = [reviewDictionary objectForKey:kCondensedRecentReviews];
            if (reviews == nil) {
                [[MMDBFetcher get] getItemRatings:_currentMenuItem.itemid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            } else
                if (self.reviewViewFlag) {
                    condensedReviews = [reviewDictionary objectForKey:kAllTopReviews];
                }else{
                    condensedReviews = reviews;
                }
            break;
        
        case 1:
            reviews = [reviewDictionary objectForKey:kCondensedTopReviews];
            
            if (reviews == nil) {
                [[MMDBFetcher get] getItemRatingsTop:_currentMenuItem.itemid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            } else
                if (self.reviewViewFlag) {
                    condensedReviews = [reviewDictionary objectForKey:kAllTopReviews];
                }else{
                    condensedReviews = reviews;
                }
            
            break;
        default:
            break;
    }
    [self.ratingsCollectionView reloadData];
}

- (IBAction)saveButton:(id)sender {
    MMMenuItemRating *currentRating = [[MMMenuItemRating alloc] init];
    currentRating.rating = [NSNumber numberWithInteger:ratingValue];
    if ((self.userReviewField.text == nil || [self.userReviewField.text isEqualToString:@""]) || [self.userReviewField.text isEqualToString:@"Please enter your review here..."]) {

        currentRating.review = @"";
    } else {
        currentRating.review = self.userReviewField.text;
    }
    currentRating.menuid = self.currentMenuItem.itemid;
    currentRating.merchid = self.currentMerchant.mid;
    currentRating.useremail = userProfile.email;
    [[MMDBFetcher get] addMenuRating:currentRating];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}

- (IBAction)clearButton:(id)sender {
    self.userReviewField.text = @"Please enter your review here...";
    self.rating = nil;
    [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Rate This Item"] forState:UIControlStateNormal];
    [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didAddEatenThis:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response {
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
    else if (succesful) {
        _eatenThisButton.enabled = NO;
        _eatenThisButton.backgroundColor = [UIColor lightBackgroundGray];
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }
}

- (IBAction)iveEatenThis:(id)sender {
    _eatenThisButton.enabled = NO;
    _eatenThisButton.backgroundColor = [UIColor lightBackgroundGray];
    [[MMDBFetcher get] eatenThis:userProfile.email withMenuItem:_currentMenuItem.itemid withMerch:_currentMenuItem.merchid];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}




@end
