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
#import "UIColor+MyMenuColors.h"
#import "MMMenuItemCell.h"
#import "MMMenuItemViewController.h"
#import "MMMenuItemRating.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"
#import "MMReviewPopOverViewController.h"
#import "MMMenuItemCollectionViewFlowLayout.h"
#import "MMRestaurantViewModel.h"
#import "MMPresentationFormatter.h"
#import "MMRestaurantReviewCell.h"

#import <HMSegmentedControl/HMSegmentedControl.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MMMerchantService.h"

#define CONTAINER_PADDING 5.0f

@interface MMRestaurantViewController ()

@property(nonatomic, strong) HMSegmentedControl *categorySegmentControl;
@property(nonatomic, weak) IBOutlet UIGestureRecognizer *leftSwipeGestureForCategory;
@property(nonatomic, weak) IBOutlet UIGestureRecognizer *rightSwipeGestureForCategory;
@property(nonatomic, getter = isSearching) BOOL searching;
@property(nonatomic, strong) NSString *currentValueInSearchBar;
@property(nonatomic) UIDeviceOrientation currentOrientation;

- (IBAction)changeCategoryBySwipe:(UISwipeGestureRecognizer *)sender;

@end

@implementation MMRestaurantViewController

MMMenuItem *touchedItem;
MMMenuItemRating *touchedReview;

#pragma mark - View Controller Methods

- (void)awakeFromNib {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.viewModel = [[MMRestaurantViewModel alloc] init];
        self.searching = NO;
        self.currentValueInSearchBar = @"";		
    }
    
    return self;
}

- (UIDeviceOrientation)translateFromUIInterfaceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    return UIInterfaceOrientationIsPortrait(orientation) ? UIDeviceOrientationPortrait : UIDeviceOrientationLandscapeLeft;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.merchantNameLabel.adjustsFontSizeToFitWidth = true;
    
    if (![self.currentValueInSearchBar isEqualToString:@""]) {
        self.searchBar.text = self.currentValueInSearchBar;
        self.searchBar.text = @"";
    }
    
    self.currentOrientation = [self translateFromUIInterfaceOrientation];
    
    [self configureCollectionViewLayoutCellSizeForCurrentOrientation];
    [self.menuItemsCollectionView reloadData];
    
	[self subscribeToNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self unsubscribeFromNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self hideAllViewsBeforeDataLoads];
    
    @weakify(self);
    [[[[MMMerchantService sharedService] getMerchantWithMerchantID:self.currentMerchantId]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(MMMerchant *currentMerchant) {
            @strongify(self);
            self.viewModel.merchantInformation = currentMerchant;
            
            [self configureViewModelDatabindings];
            
            [self performDataLoadForCategorySegmentedControl];
            [self performDataLoadForCollectionView];
            
            [self configureSearchBar];
            [self configureMainCollectionView];
            
            [self configureOtherViews];
			
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMenuItem"]) {
        MMMenuItemViewController *menuItemController = [segue destinationViewController];
        
        menuItemController.currentMenuItem = touchedItem;
        menuItemController.currentMerchant = self.viewModel.merchantInformation;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation Change Methods

- (void)didReceiveOrientationChangeNotification:(NSNotification *)notification {
    self.currentOrientation = [self translateFromUIInterfaceOrientation];
    
	CGSize segmentControlSize = self.reviewOrderBySegmentControl.frame.size;
	[self.reviewOrderBySegmentControl removeFromSuperview];
    self.reviewOrderBySegmentControl.frame = CGRectMake((self.view.frame.size.width / 2.0) - segmentControlSize.width / 2.0, 10, segmentControlSize.width, segmentControlSize.height);
    
    [self.searchBar performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    
    if (!self.searching) {
        [self.menuItemsCollectionView performSelectorOnMainThread:@selector(addSubview:) withObject:self.searchBar waitUntilDone:YES];
        [self addSpaceForSearchBarInCollectionView];
    }
    
    [self configureCollectionViewLayoutCellSizeForCurrentOrientation];
    
    [self.menuItemsCollectionView reloadData];
	
	if (self.searchBar.isHidden) {
		[self.menuItemsCollectionView addSubview:self.reviewOrderBySegmentControl];
	}
}

- (void)configureCollectionViewLayoutCellSizeForCurrentOrientation {
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.menuItemsCollectionView.collectionViewLayout;
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

#pragma mark - Gesture Recognition Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)changeCategoryBySwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self handleSwipeLeft];
    }
    else {
        [self handleSwipeRight];
    }
}

#pragma mark - Register/Unregister Notification Methods

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveViewUp:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveViewDown:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)unsubscribeFromOrientationNotifications {

}

- (void)subscribeToOrientationNotifications {

}

#pragma mark - Keyboard/Scrolling Methods

- (CGFloat)getSearchBarVerticalOffsetWhileSearching {
    return self.categorySegmentControl.frame.origin.y + self.categorySegmentControl.frame.size.height + + CONTAINER_PADDING - self.searchBar.frame.size.height;
}

- (void)moveViewUp:(NSNotification *)notification {
    if (!self.searching) return;
    
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - [self getSearchBarVerticalOffsetWhileSearching], oldFrame.size.width, oldFrame.size.height);
    
    [self removeSpaceForSearchBarInCollectionView];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:newFrame];
    }];
}

- (void)moveViewDown:(NSNotification *)notification {
    if (![self isViewPushedUp:self.view.frame]) {
        return;
    }
	
	UISearchBar *newSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 10.0f, self.view.frame.size.width, 44.0f)];
    newSearchBar.placeholder = NSLocalizedString(@"Search for Menu Item", nil);
    newSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if (![self.currentValueInSearchBar isEqualToString:@""]) {
        newSearchBar.text = self.currentValueInSearchBar;
        self.currentValueInSearchBar = @"";
    }
    
    [self.menuItemsCollectionView addSubview:newSearchBar];
    [self addSpaceForSearchBarInCollectionView];
    
    newSearchBar.delegate = self;
    self.searchBar = newSearchBar;
    
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + [self getSearchBarVerticalOffsetWhileSearching], oldFrame.size.width, oldFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:newFrame];
    }];
}

- (void)removeSpaceForSearchBarInCollectionView {
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.menuItemsCollectionView.collectionViewLayout;
	
    layout.viewHeight = 0.0f;
	[layout setSectionInset:UIEdgeInsetsMake(0, 0, 25.0f, 0)];
    
    [self.menuItemsCollectionView reloadData];
}

- (void)addSpaceForSearchBarInCollectionView {
    MMMenuItemCollectionViewFlowLayout *layout = (MMMenuItemCollectionViewFlowLayout *)self.menuItemsCollectionView.collectionViewLayout;
	
    layout.viewHeight = 54.0f;
	[layout setSectionInset:UIEdgeInsetsMake(54.0f, 0, 0, 0)];
    
    [self.menuItemsCollectionView reloadData];
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
    
    self.merchantRatingLabel.text = [MMPresentationFormatter formatRatingForRawRating:self.viewModel.merchantInformation.rating];
    self.merchantHoursLabel.text = [MMPresentationFormatter formatBusinessHoursForOpenTime:self.viewModel.merchantInformation.opentime withCloseTime:self.viewModel.merchantInformation.closetime];
    
    // Ignore the first signal since don't care about the
    // initial binding to the selectedTabIndex; only the
    // signals afterwards when the user actually changes
    // the tab.
    [[[RACObserve(self.viewModel, selectedTabIndex) skip:1]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *tabIndex) {
            self.searchBar.text = @"";
			
            if ([tabIndex isEqualToNumber:self.viewModel.reviewTabIndex]) {
                [self configureCollectionViewForReviews];
            }
            else {
                [self configureCollectionViewForMenuItems];
            }

            [self.menuItemsCollectionView reloadData];
    }];
    
    [[self.viewModel.controllerShouldReloadDataSource
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id x) {
            [self.menuItemsCollectionView reloadData];
    }];

    [[self.viewModel.controllerShouldShowProgressIndicator
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *show) {
            if ([show isEqualToNumber:@YES]) {
                // Don't allow user to switch tabs while data
                // is loading.
                self.categorySegmentControl.enabled = FALSE;
                [MBProgressHUD showHUDAddedTo:self.menuItemsCollectionView animated:YES];
            }
            else if ([show isEqualToNumber:@NO]) {
                // Enable user to switch tabs again.
                self.categorySegmentControl.enabled = TRUE;
                [MBProgressHUD hideAllHUDsForView:self.menuItemsCollectionView animated:YES];
            }
    }];
}

- (void)performDataLoadForCategorySegmentedControl {
    @weakify(self);
    [[[self.viewModel getTabCategories]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSArray *categories) {
            @strongify(self);
         
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
            [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
            [self configureCategorySegmentControlWithCategories:categories];
        }
        error:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
         
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                           message:@"Unable to communicate with server."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [message show];
     }];
}

#pragma mark - Popover View Controller Methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return FALSE;
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searching = NO;
    
    if ([self.viewModel numberOfItemsInCurrentDataSource] == 1) {
        touchedItem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self performSegueWithIdentifier:@"showMenuItem" sender:self];
    }

    self.currentValueInSearchBar = searchBar.text;
    
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];

    [self.menuItemsCollectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searching = NO;
    
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    
    [self.viewModel searchForItemWithValue:@""];
    
    [self.menuItemsCollectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searching = YES;
    searchBar.showsCancelButton = YES;
    
    [searchBar removeFromSuperview];
    CGRect oldFrame = self.view.frame;
    
	searchBar.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + [self getSearchBarVerticalOffsetWhileSearching] - 64, self.view.frame.size.width, searchBar.frame.size.height);
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    self.searchBar = searchBar;
}

- (void)configureCollectionViewForSearching {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.viewModel searchForItemWithValue:searchText];
    [self.menuItemsCollectionView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return !self.searching;
}

#pragma mark - Configure Category Segment Control Methods

- (void)configureCategorySegmentControlWithCategories:(NSArray *)categories {
    [self configureCategorySegmentAppearance:categories];
    [self configureCategorySegmentEvents];
    [self configureConstraintsForCategorySegment];
}

- (void)configureConstraintsForCategorySegment {
    [self.view addSubview:self.categorySegmentControl];
    
    NSDictionary *viewsDictionary = @{
        @"merchantInformationContainer": self.merchantInformationContainer,
        @"categorySegmentControl": self.categorySegmentControl,
        @"menuItemsCollectionView": self.menuItemsCollectionView,
        @"merchantImageView": self.merchantImageView
    };
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[merchantInformationContainer]-5-[categorySegmentControl]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[categorySegmentControl]-5-[menuItemsCollectionView]" options:0 metrics:nil views:viewsDictionary];
    
    [self.view addConstraints:constraint1];
    [self.view addConstraints:constraint2];
}

- (void)configureCategorySegmentAppearance:(NSArray *)categories {
    self.categorySegmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:categories];
    self.categorySegmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	
	self.categorySegmentControl.frame = CGRectMake(10, self.merchantInformationContainer.frame.origin.y + self.merchantInformationContainer.frame.size.height + 5, self.view.frame.size.width-20, 60);
	
    self.categorySegmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.categorySegmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.categorySegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.categorySegmentControl.scrollEnabled = NO;
    self.categorySegmentControl.selectionIndicatorColor = [UIColor tealColor];
	self.categorySegmentControl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    self.categorySegmentControl.layer.masksToBounds = NO;
    self.categorySegmentControl.layer.shadowColor = [UIColor blackColor].CGColor;
    self.categorySegmentControl.layer.shadowOpacity = 0.3;
    self.categorySegmentControl.layer.shadowRadius = 2;
    self.categorySegmentControl.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
	[self.categorySegmentControl sizeToFit];
}

- (void)configureCategorySegmentEvents {
    RAC(self.categorySegmentControl, selectedSegmentIndex, 0) = RACObserve(self.viewModel, selectedTabIndex);
    
    @weakify(self);
    [[self.categorySegmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(HMSegmentedControl *sender) {
        @strongify(self);
        
        self.viewModel.selectedTabIndex = sender.selectedSegmentIndex;
    }];
}

#pragma mark - Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.viewModel.dataSourceType == MMReviewsDataSource) {
        return [self configureReviewCell:indexPath collectionView:collectionView];
    } else {
        return [self configureMenuItemCell:indexPath collectionView:collectionView];
    }
}

#pragma mark - Collection View Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInCurrentDataSource];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataSourceType == MMReviewsDataSource) {
        [self selectItemInReviewCollection:indexPath collectionView:collectionView];
    } else {
        [self selectItemInMenuItemCollection:indexPath collectionView:collectionView];
    }
}

#pragma mark - Private Helper Methods

- (void)hideAllViewsBeforeDataLoads {
    [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)configureSearchBar {
	UISearchBar *searchBar;
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 10.0f, self.view.frame.size.width, 44.0f)];

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
    
    layout.viewHeight = 54.0f;
    [layout setSectionInset:UIEdgeInsetsMake(54.0f, 0.0f, 25.0f, 0.0f)];
    [self.menuItemsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    [self.menuItemsCollectionView registerNib:[UINib nibWithNibName:@"RestaurantReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
}

- (void)hideSearchBarInCollectionView {
    if (self.viewModel.numberOfItemsInCurrentDataSource == 0)
        return;
    
    [self.menuItemsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)configureOtherViews {
    self.merchantImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.viewModel.merchantInformation.picture]]];
    self.ratingView.backgroundColor = [UIColor lightBackgroundGray];
    self.ratingView.layer.cornerRadius = 17.5;
}

- (void)performDataLoadForCollectionView {
    [[self.viewModel getAllMenuItems] subscribeNext:^(id x) {
        [self.menuItemsCollectionView reloadData];
        [self hideSearchBarInCollectionView];
    }];
}

- (void)configureCollectionViewForReviews {
    self.searchBar.hidden = YES;
    [self configureOrderBySegmentControl];
    [self showShowOrderBySegmentControl];
}

- (void)configureCollectionViewForMenuItems {
    self.searchBar.hidden = NO;
    [self hideOrderBySegmentControl];
}

- (MMRestaurantReviewCell *)retrieveReviewCellForIndexPath:(NSIndexPath *)indexPath fromCollectionView:(UICollectionView *)collectionView {
    static NSString *identifier = @"ReviewCell";
    
    MMRestaurantReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantReviewCell" owner:self options:NULL] objectAtIndex:0];
    }
    
    return cell;
}

- (UICollectionViewCell *)configureReviewCell:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    MMRestaurantReviewCell *cell = [self retrieveReviewCellForIndexPath:indexPath
                                                   fromCollectionView:collectionView];
    MMMenuItemRating *menitem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:indexPath];
    
    cell = (MMRestaurantReviewCell *) [self configureCellSizeWithCell:cell];
    
    [cell updateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    cell.ratingBg.layer.cornerRadius = 5;
    cell.userInteractionEnabled = YES;
    
    cell.menuItemName.text = menitem.menuitemname;
    cell.ratinglabel.text = [MMPresentationFormatter formatRatingForRawRating:menitem.rating];
    cell.upVoteCountLabel.text = [NSString stringWithFormat:@"%@", menitem.likeCount];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", menitem.firstname, menitem.lastname];
    cell.reviewView.text = menitem.review;
    
    return cell;
}

- (void)handleSwipeLeft {
    if (self.categorySegmentControl.selectedSegmentIndex == 0) {
        return;
    }
    else {
        [self.categorySegmentControl setSelectedSegmentIndex:self.categorySegmentControl.selectedSegmentIndex-1 animated:YES];
        self.viewModel.selectedTabIndex = self.categorySegmentControl.selectedSegmentIndex;
    }
}

- (void)handleSwipeRight {
    if (self.categorySegmentControl.selectedSegmentIndex == self.viewModel.reviewTabIndex.integerValue) {
        return;
    }
    else {
        [self.categorySegmentControl setSelectedSegmentIndex:self.categorySegmentControl.selectedSegmentIndex+1 animated:YES];
        self.viewModel.selectedTabIndex = self.categorySegmentControl.selectedSegmentIndex;
    }
}

- (MMMenuItemCell *)retrieveMenuItemCellForItemPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    static NSString *identifier = @"Cell";
    
    MMMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.userInteractionEnabled = YES;
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:NULL] objectAtIndex:0];
    }
    
    return cell;
}

- (UICollectionViewCell *)configureMenuItemCell:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    MMMenuItem *menuItem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:indexPath];
    MMMenuItemCell *cell = [self retrieveMenuItemCellForItemPath:indexPath collectionView:collectionView];
    
    cell = (MMMenuItemCell *) [self configureCellSizeWithCell:cell];
    
    [cell updateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    cell.ratingBg.backgroundColor = [UIColor lightBackgroundGray];
    cell.ratingBg.layer.cornerRadius = 5;
    cell.userInteractionEnabled = YES;
    
    [cell.menuImageView setImageWithURL:[NSURL URLWithString:menuItem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    cell.titleView.text = menuItem.name;
    cell.priceLabel.text = [MMPresentationFormatter formatNumberAsPrice:menuItem.cost];
    cell.ratinglabel.text = [MMPresentationFormatter formatRatingForRawRating:menuItem.rating];
    cell.descriptionView.text = menuItem.desc;
    
    cell.restrictedImage.image = (menuItem.restrictionflag) ? [UIImage imageNamed:@"restriction.png"] : nil;
    
    return cell;
}

- (void)selectItemInReviewCollection:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {

    MMMenuItemRating *selectedReview = [self.viewModel getItemFromCurrentDataSourceForIndexPath:indexPath];
    
    MMBaseNavigationController *reviewNavPop = [self.storyboard instantiateViewControllerWithIdentifier:@"popOverNavigation"];
    
    MMReviewPopOverViewController *reviewPop = [reviewNavPop.viewControllers firstObject];
    reviewPop.selectedRestaurant = self.viewModel.merchantInformation;
    reviewPop.menuItemReview = selectedReview;
    
    @weakify(self)
    reviewPop.callback = ^(BOOL done) {
        @strongify(self)
        [self.popOverController dismissPopoverAnimated:YES];
    };
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:reviewNavPop];
    popover.delegate = self;
    
    reviewPop.oldPopOverController = popover;
    self.popOverController = popover;
    
    [self.popOverController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-150, 1, 1)
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionDown
                                          animated:YES];
}

- (void)selectItemInMenuItemCollection:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    touchedItem = [self.viewModel getItemFromCurrentDataSourceForIndexPath:indexPath];
    
    if ([self.searchBar isFirstResponder]) {
        self.currentValueInSearchBar = self.searchBar.text;
        [self.searchBar performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
    
    [self performSegueWithIdentifier:@"showMenuItem" sender:self];
}

- (void)configureOrderBySegmentControl {
    if (self.reviewOrderBySegmentControl)
        return;
	
    CGSize segmentControlSize;
    segmentControlSize = CGSizeMake(300.0, 30.0);

	CGRect segmentControlFrame = CGRectMake((self.view.frame.size.width/ 2.0) - segmentControlSize.width / 2.0, 10, segmentControlSize.width, segmentControlSize.height);
	
    self.reviewOrderBySegmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Recent", nil), NSLocalizedString(@"Top Rated", nil)]];

    self.reviewOrderBySegmentControl.frame = segmentControlFrame;
    self.reviewOrderBySegmentControl.alpha = 1.0;
    self.reviewOrderBySegmentControl.backgroundColor = [UIColor whiteColor];
    self.reviewOrderBySegmentControl.selectedSegmentIndex = MMOrderByRecent;
    self.reviewOrderBySegmentControl.tintColor = [UIColor tealColor];
    self.reviewOrderBySegmentControl.opaque = NO;
    
    RACChannelTo(self.viewModel, reviewOrder) = [self.reviewOrderBySegmentControl rac_newSelectedSegmentIndexChannelWithNilValue:@-1];
}

- (void)showShowOrderBySegmentControl {
	if(self.reviewOrderBySegmentControl)
		[self.menuItemsCollectionView addSubview:self.reviewOrderBySegmentControl];
}

- (void)hideOrderBySegmentControl {
    [self.reviewOrderBySegmentControl removeFromSuperview];
}

- (BOOL)isViewPushedUp:(CGRect)frame {
    return (frame.origin.y < 0);
}

@end
