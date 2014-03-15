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

#import "MMRestaurantViewController.h"
#import "MMMenuItem.h"
#import "MMMerchant.h"
#import "MBProgressHUD.h"
#import "UIColor+MyMenuColors.h"
#import "MMMenuItemCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMMenuItemViewController.h"
#import "MMMenuItemRating.h"
#import "MMMenuItemReviewCell.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"
#import "MMReviewPopOverViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "MMMenuItemCollectionViewFlowLayout.h"
#import "MMRestaurantViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#define kmenuItems @"kmenuItems"
#define kReview @"kReview"
#define kCondensedTopReviews @"condensedTopReviews"
#define kCondensedRecentReviews @"condensedRecentReviews"
#define kAllRecentReviews @"allRecentReviews"
#define kAllTopReviews @"allTopReviews"
#define kCategories @"kCategories"

@interface MMRestaurantViewController ()

@property(nonatomic, strong) HMSegmentedControl *categorySegmentControl;
@property(nonatomic, weak) IBOutlet UIGestureRecognizer *leftSwipeGestureForCategory;
@property(nonatomic, weak) IBOutlet UIGestureRecognizer *rightSwipeGestureForCategory;

- (IBAction)changeCategoryBySwipe:(UISwipeGestureRecognizer *)sender;

@end

@implementation MMRestaurantViewController


MMMenuItem *touchedItem;
MMMenuItemRating *touchedReview;
NSMutableArray *condensedReviews;
NSMutableArray *allReviews;
NSMutableDictionary *reviewDictionary;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.viewModel = [[MMRestaurantViewModel alloc] init];
    }
    
    return self;
}

#pragma mark - View Controller Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideAllViewsBeforeDataLoads];
    
    [self configureViewModel];
    [self configureViewModelDatabindings];
    
    [self performDataLoadForCategorySegmentedControl];
    [self performDataLoadForCollectionView];
    
    [self configureSearchBar];
    [self configureMainCollectionView];
    
    [self configureOtherViews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMenuItem"]) {
        MMMenuItemViewController *menuItemController = [segue destinationViewController];
        menuItemController.currentMenuItem = touchedItem;
        menuItemController.currentMerchant = _currentMerchant;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognition Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)changeCategoryBySwipe:(UISwipeGestureRecognizer *)sender {
    NSInteger currentIndex = self.categorySegmentControl.selectedSegmentIndex;
    NSInteger firstSegmentIndex = 0;
    NSInteger lastSegmentIndex = [self.categorySegmentControl.sectionTitles count] - 1;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.categorySegmentControl.selectedSegmentIndex == firstSegmentIndex) {
            return;
        }
        else {
            [self.categorySegmentControl setSelectedSegmentIndex:currentIndex-1 animated:YES];
            self.viewModel.selectedTabIndex = currentIndex - 1;
        }
    }
    else {
        if (self.categorySegmentControl.selectedSegmentIndex == lastSegmentIndex) {
            return;
        }
        else {
            [self.categorySegmentControl setSelectedSegmentIndex:currentIndex+1 animated:YES];
            self.viewModel.selectedTabIndex = currentIndex + 1;
        }
    }
}

#pragma mark - Register/Unregister Notification Methods

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveViewUp:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveViewDown:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Keyboard/Scrolling Methods

- (void)moveViewUp:(NSNotification *)notification {
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 275, oldFrame.size.width, oldFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:newFrame];
    }];
}

- (void)moveViewDown:(NSNotification *)notification {
    UISearchBar *newSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0f, 44.0f)];
    newSearchBar.placeholder = NSLocalizedString(@"Search for Menu Item", nil);
    
    [self.menuItemsCollectionView addSubview:newSearchBar];
    
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.menuItemsCollectionView.collectionViewLayout;
    
    layout.viewHeight = 44.0f;
    [layout setSectionInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    
    newSearchBar.delegate = self;
    self.searchBar = newSearchBar;
    
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 275, oldFrame.size.width, oldFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:newFrame];
    }];
}

#pragma mark - RX Event Wire-up Methods

- (void)configureViewModelDatabindings {
    RACChannelTo(self, merchantNameLabel.text) =
    RACChannelTo(self.viewModel.merchantInformation, businessname);
    
    RACChannelTo(self, merchantDescriptionTextView.text) =
    RACChannelTo(self.viewModel.merchantInformation, desc);
    
    RACChannelTo(self, merchantPhoneNumberLabel.text) =
    RACChannelTo(self.viewModel.merchantInformation, phone);
    
    RACChannelTo(self, merchantAddressLabel.text) =
    RACChannelTo(self.viewModel.merchantInformation, address);
    
    RAC(self, merchantRatingLabel.text) = [self.viewModel formatRatingForRawRating:self.viewModel.merchantInformation.rating];
    
    RAC(self, merchantHoursLabel.text) = [self.viewModel formatBusinessHoursForOpenTime:self.viewModel.merchantInformation.opentime withCloseTime:self.viewModel.merchantInformation.closetime];
    
    [RACObserve(self.viewModel, selectedTabIndex) subscribeNext:^(id x) {
        [self.menuItemsCollectionView reloadData];
    }];
}

- (void)performDataLoadForCategorySegmentedControl {
    @weakify(self);
    [[[self.viewModel getTabCategories] deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *categories) {
         @strongify(self);
         
         [self configureCategorySegmentControlWithCategories:categories];
         //[self hideSearchBarInCollectionView];
     } error:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
         
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                           message:@"Unable to communicate with server."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
         [message show];
     } completed:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
     }];
}

- (void)configureViewModel {
    self.viewModel.merchantInformation = self.currentMerchant;
}

#pragma mark - Popover View Controller Methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return FALSE;
}

- (IBAction)cancelToMainScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([self.viewModel numberOfItemsInCurrentDataSource] == 1) {
        touchedItem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self performSegueWithIdentifier:@"showMenuItem" sender:self];
    }
    
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    
    [self.viewModel searchForItemWithValue:@""];
    [self.menuItemsCollectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    
    [self.viewModel searchForItemWithValue:@""];
    [self.menuItemsCollectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    
    [searchBar removeFromSuperview];
    CGRect oldFrame = self.view.frame;
    searchBar.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 275 - 64, searchBar.frame.size.width, searchBar.frame.size.height);
    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    self.searchBar = searchBar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.viewModel searchForItemWithValue:searchText];
    [self.menuItemsCollectionView reloadData];
}

#pragma mark - Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.restorationIdentifier isEqualToString:@"ReviewCollection"]) {
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
        
        if ([menitem.useremail isEqualToString:@"See More Reviews"]) {
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
    } else {
        static NSString *identifier = @"Cell";
        
        MMMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:NULL] objectAtIndex:0];
        }
        // Rounded Corners
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.cornerRadius = 5;
        cell.contentView.layer.masksToBounds = YES;
        
        MMMenuItem *menitem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:indexPath];
        
        UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
        [imageView setImageWithURL:[NSURL URLWithString:menitem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
        // Set the text
        UILabel *textTitle = (UILabel *) [cell viewWithTag:101];
        textTitle.numberOfLines = 2;
        //[textTitle sizeToFit];
        UILabel *textDesc = (UILabel *) [cell viewWithTag:102];
        UILabel *textPrice = (UILabel *) [cell viewWithTag:103];
        UILabel *textRating = (UILabel *) [cell viewWithTag:104];
        UILabel *textMod = (UILabel *) [cell viewWithTag:105];
        UIView *labelBack = (UIView *) [cell viewWithTag:106];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        NSNumberFormatter *formatterCost = [[NSNumberFormatter alloc] init];
        [formatterCost setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatterCost setMaximumFractionDigits:3];
        [formatterCost setMinimumFractionDigits:2];
        labelBack.backgroundColor = [UIColor lightBackgroundGray];
        labelBack.layer.cornerRadius = 5;
        textPrice.text = [NSString stringWithFormat:@"$%@", [formatterCost stringFromNumber:menitem.cost]];
        NSString * rate = [formatter stringFromNumber:menitem.rating];
        if ([rate isEqualToString:@".0"]){
            rate = @"N/A";
        }
        textRating.text = rate;
        textTitle.text = menitem.name;
        textDesc.text = menitem.desc;
        cell.menuItem = menitem;
        if (menitem.restrictionflag == FALSE) {
            textMod.text = @"";
        }
        else {
            textMod.text = @"!";
        }
        return cell;
    }
}

#pragma mark - Configure Category Segment Control Methods

- (void)configureCategorySegmentControlWithCategories:(NSArray *)categories {
    [self configureCategorySegmentAppearance:categories];
    [self configureCategorySegmentEvents];
    
    [self.view addSubview:self.categorySegmentControl];
}

- (void)configureCategorySegmentAppearance:(NSArray *)categories {
    self.categorySegmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:categories];
    self.categorySegmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.categorySegmentControl.frame = CGRectMake(10, 215, 1014, 60);
    self.categorySegmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.categorySegmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.categorySegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.categorySegmentControl.scrollEnabled = YES;
    self.categorySegmentControl.selectionIndicatorColor = [UIColor tealColor];
}

- (void)configureCategorySegmentEvents {
    RAC(self.categorySegmentControl, selectedSegmentIndex, 0) = RACObserve(self.viewModel, selectedTabIndex);
    
    @weakify(self);
    [[self.categorySegmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(HMSegmentedControl *sender) {
        @strongify(self);
        
        self.viewModel.selectedTabIndex = sender.selectedSegmentIndex;
    }];
}

#pragma mark - Collection View Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInCurrentDataSource];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.restorationIdentifier isEqualToString:@"ReviewCollection"]) {
        [self selectItemInReviewCollection:indexPath collectionView:collectionView];
    } else {
        [self selectItemInMenuItemCollection:indexPath collectionView:collectionView];
    }
}

- (void)selectItemInReviewCollection:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    MMMenuItemReviewCell *itemCell = (MMMenuItemReviewCell *) cell;
    
    touchedReview = [[MMMenuItemRating alloc] init];
    touchedReview = itemCell.rating;
    
    MMBaseNavigationController *reviewNavPop = [self.storyboard instantiateViewControllerWithIdentifier:@"popOverNavigation"];
    
    MMReviewPopOverViewController *reviewPop = [reviewNavPop.viewControllers firstObject];
    reviewPop.delegate = self;
    
    reviewPop.selectedRestaurant = _currentMerchant;
    //reviewPop.reviewSize = self.
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:reviewNavPop];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReview object:touchedReview];
    
    popover.delegate = self;
    reviewPop.oldPopOverController = popover;
    self.popOverController = popover;
    
    // Make sure keyboard is hidden before you show popup.
    
    [self.popOverController presentPopoverFromRect:cell.frame
                                            inView:cell.superview
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
}

- (void)selectItemInMenuItemCollection:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    MMMenuItemCell *itemCell = (MMMenuItemCell *) cell;
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    touchedItem = [[MMMenuItem alloc] init];
    touchedItem = itemCell.menuItem;
    [self performSegueWithIdentifier:@"showMenuItem" sender:self];
}

#pragma mark - Stuff to remove/update

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
        //[self.reviewsCollectionView reloadData];
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
        //[self.reviewsCollectionView reloadData];
    }
    
}

- (void)changeReviewSort:(UISegmentedControl *)control {
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    switch ([control selectedSegmentIndex]) {
        case 0:
            reviews = [reviewDictionary objectForKey:kCondensedTopReviews];
            if (reviews == nil) {
                //[[MMDBFetcher get] getItemRatingsMerchantTop:_currentMerchant.mid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            } else
                condensedReviews = reviews;
            
            break;
        case 1:
            reviews = [reviewDictionary objectForKey:kCondensedRecentReviews];
            if (reviews == nil) {
                //[[MMDBFetcher get] getItemRatingsMerchant:_currentMerchant.mid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            } else
                condensedReviews = reviews;
            break;
        default:
            break;
    }
    //[self.reviewsCollectionView reloadData];
}

#pragma mark - Private Methods

- (void)hideAllViewsBeforeDataLoads {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
}

- (void)configureSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0f, 44.0f)];
    searchBar.placeholder = NSLocalizedString(@"Search for Menu Item", nil);
    searchBar.translucent = FALSE;
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
}

- (void)configureMainCollectionView {
    [self.menuItemsCollectionView setDelegate:self];
    [self.menuItemsCollectionView setAlwaysBounceVertical:YES];
    [self.menuItemsCollectionView addSubview:self.searchBar];
    
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.menuItemsCollectionView.collectionViewLayout;
    
    layout.viewHeight = 44.0f;
    [layout setSectionInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    
    [self.menuItemsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    [self.menuItemsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
}

- (void)hideSearchBarInCollectionView {
    if (self.viewModel.numberOfItemsInCurrentDataSource == 0)
        return;
    
    [self.menuItemsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)configureOtherViews {
    _merchantImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_currentMerchant.picture]]];
    _ratingView.backgroundColor = [UIColor lightBackgroundGray];
    _ratingView.layer.cornerRadius = 17.5;
}

- (void)performDataLoadForCollectionView {
    [[self.viewModel getAllMenuItems] subscribeNext:^(id x) {
        [self.menuItemsCollectionView reloadData];
        [self hideSearchBarInCollectionView];
    }];
}

@end
