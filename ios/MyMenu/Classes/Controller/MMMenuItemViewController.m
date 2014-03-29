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

- (void)awakeFromNib {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)subscribeToOrientationNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
- (void)didReceiveOrientationChangeNotification:(NSNotification *)notification {
    self.currentOrientation = [self translateFromUIInterfaceOrientation];
    [self configureCollectionViewLayoutCellSizeForCurrentOrientation];
    [self.ratingsCollectionView reloadData];
}

- (UIDeviceOrientation)translateFromUIInterfaceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    return UIInterfaceOrientationIsPortrait(orientation) ? UIDeviceOrientationPortrait : UIDeviceOrientationLandscapeLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    reviewDictionary = [[NSMutableDictionary alloc] init];
    mods = [[NSMutableArray alloc] init];
    
    self.rating = nil;
    self.userReviewField.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self configureView];
    [[self.userReviewField layer] setBorderColor:[[UIColor tealColor] CGColor]];
    [[self.userReviewField layer] setBorderWidth:2.3];
    [[self.userReviewField layer] setCornerRadius:5];
    
    userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getModifications:_currentMenuItem.itemid withUser:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self.ratingsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];

    [self.ratingsCollectionView reloadData];

    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
        _eatenThisButton.hidden = YES;
    }
    else {
        _eatenThisButton.hidden = NO;
        _eatenThisButton.enabled = YES;
        _eatenThisButton.backgroundColor = [UIColor lightTealColor];
        [[MMDBFetcher get] userEaten:userProfile.email withItem:_currentMenuItem.itemid];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self subscribeToOrientationNotifications];
    self.currentOrientation = [self translateFromUIInterfaceOrientation];
    [self configureCollectionViewLayoutCellSizeForCurrentOrientation];
    [self.ratingsCollectionView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self unsubscribeFromOrientationNotifications];
}
- (void)unsubscribeFromOrientationNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
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
}

- (void)didRetrieveTopItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    condensedReviews = [[NSMutableArray alloc] init];
    allReviews = [[NSMutableArray alloc] init];
    
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
            condensedReviews = [ratings mutableCopy];
        }

        [reviewDictionary setObject:allReviews forKey:kAllTopReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedTopReviews];
        
        if (self.reviewViewFlag) {
            condensedReviews = [reviewDictionary objectForKey:kAllTopReviews];
        }
        
        [self.ratingsCollectionView reloadData];
        [self.tableView reloadData];
    }

}

- (void)didRetrieveRecentItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
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
            condensedReviews = [ratings mutableCopy];
        }

        [reviewDictionary setObject:allReviews forKey:kAllRecentReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedRecentReviews];
        
        if (self.reviewViewFlag) {
            condensedReviews = [reviewDictionary objectForKey:kAllRecentReviews];
        }
        
        [self.ratingsCollectionView reloadData];
        [self.tableView reloadData];
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
            mods = [NSMutableArray new];
            [mods addObject:@"There are not any modifications available for this dish."];
        }
        
        [mods replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"- %@", [mods firstObject]]];
        self.menuModificationsView.text = [mods componentsJoinedByString:@"\n- "];
        self.menuModificationsView.font = [UIFont systemFontOfSize:16];
        [self.menuModificationsView sizeToFit];
        self.menuModificationsView.editable = NO;
        self.menuModificationsView.userInteractionEnabled = NO;
        
        [self.tableView reloadData];
        [[MMDBFetcher get] getItemRatings:_currentMenuItem.itemid];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareMenuItem:(id)sender {
    UIViewController *controller = [MMSocialMediaService shareMenuItem:self.currentMenuItem];

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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqual:@"Please enter your review here..."]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqual:@""]) {
        textView.text = @"Please enter your review here...";
        [textView resignFirstResponder];
    }
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
    }
    else {
        self.userReviewField.text = @"Please enter your review here...";
        [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Rate This Item"] forState:UIControlStateNormal];
        [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 301;
    switch (indexPath.section){
        case 1:
            height = self.menuModificationsView.frame.size.height + 5;
            break;
        case 2:
            height = self.userReviewField.frame.size.height + 10;
            break;
        case 3:
            if (condensedReviews.count == 0){
                height = 0;
            }else
                if (UIDeviceOrientationIsPortrait(self.currentOrientation)) {
                    NSInteger oddHeightCheck = (((condensedReviews.count % 2) == 1) ? condensedReviews.count+1 : condensedReviews.count);
                    height =(oddHeightCheck * 120/2) + 20;
                }else{
                    height =(condensedReviews.count * 120) + 20;
            }
            break;
        default:
            break;
    }
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 32.0f)];
    header.backgroundColor = [UIColor tealColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 4.0, 200.0f, 16.0f)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    
    switch (section) {
        case 1:
            label.text = NSLocalizedString(@"Modifications", nil);
            break;
        case 2:
            label.text = NSLocalizedString(@"Submit Rating", nil);
            break;
        case 3:
            label.text = NSLocalizedString(@"Reviews", nil);
            break;
        default:
            break;
    }
    
    [header addSubview:label];
    
    return header;
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
- (void)configureCollectionViewLayoutCellSizeForCurrentOrientation {
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.ratingsCollectionView.collectionViewLayout;
    if (UIDeviceOrientationIsPortrait(self.currentOrientation)) {
        layout.itemSize = CGSizeMake(384.0f, 113.0f);
    }
    else {
        layout.itemSize = CGSizeMake(700.0f, 113.0f);
    }
}

- (UICollectionViewCell *)configureCellSizeWithCell:(UICollectionViewCell *)cell {
    if (UIDeviceOrientationIsPortrait(self.currentOrientation)) {
        cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 384, cell.contentView.frame.size.height);
    }
    else {
        cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 700, cell.contentView.frame.size.height);
    }
    
    return cell;
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
    } else if (exists) {
        [_eatenThisButton setTitle:NSLocalizedString(@"I have eaten this", nil) forState:UIControlStateDisabled];
        _eatenThisButton.enabled = NO;
        _eatenThisButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        [_eatenThisButton setTitle:NSLocalizedString(@"I have not eaten this", nil) forState:UIControlStateNormal];
        _eatenThisButton.enabled = YES;
        _eatenThisButton.backgroundColor = [UIColor tealColor];
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ReviewCell";

    MMMenuItemReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell = (MMMenuItemReviewCell *) [self configureCellSizeWithCell:cell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemReviewCell" owner:self options:NULL] objectAtIndex:0];
    }
    
    MMMenuItemRating *menitem = [condensedReviews objectAtIndex:indexPath.row];
    
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.cornerRadius = 5.0f;
    cell.upVoteCountLabel.text = [NSString stringWithFormat:@"%@", menitem.likeCount];
    cell.ratinglabel.text = [MMPresentationFormatter formatRatingForRawRating:menitem.rating];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", menitem.firstname, menitem.lastname];
    cell.reviewView.text = menitem.review;
    cell.likeImageView.image = [UIImage imageNamed:@"upvote.png"];
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
