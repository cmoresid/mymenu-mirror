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
#import "MBProgressHUD.h"
#import "UIColor+MyMenuColors.h"
#import "MMDBFetcher.h"
#import "MMMenuItemCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMMenuItemViewController.h"
#import "MMMenuItemRating.h"
#import "MMMenuItemReviewCell.h"
#import "MMRestaurantPopOverViewController.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"
#import "MMReviewPopOverViewController.h"


#define kCurrentUser @"currentUser"
#define kSelectedRestaurant @"kSelectedRestaurant"
#define kmenuItems @"kmenuItems"
#define kReview @"kReview"
#define kCondensedTopReviews @"condensedTopReviews"
#define kCondensedRecentReviews @"condensedRecentReviews"
#define kAllRecentReviews @"allRecentReviews"
#define kAllTopReviews @"allTopReviews"
#define kCategories @"kCategories"

@interface MMRestaurantViewController ()

@end

@implementation MMRestaurantViewController


NSArray *menuItems;
MMMenuItem * touchedItem;
MMMenuItemRating * touchedReview;
NSMutableDictionary * menuItemDictionary;
NSMutableArray * condensedReviews;
NSMutableArray * allReviews;
NSMutableDictionary *reviewDictionary;
NSMutableArray * categories;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

// Delegate method.
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached; //or UIBarPositionTopAttached
}

- (void)restaurantSelected:(NSNotification*)notification {
    _currentMerchant = (MMMerchant*)notification.object;
}

- (IBAction)cancelToMainScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{	
    [super viewDidLoad];
    
    menuItemDictionary = [[NSMutableDictionary alloc] init];
    menuItems = [[NSArray alloc] init];
    [self.menuItemsCollectionView setDelegate:self];
    self.reviewsCollectionView.delegate = self;
    self.reviewsCollectionView.dataSource = self;
    self.navigationBar.delegate = self;
    self.searchBar.delegate = self;
    categories = [NSMutableArray new];
    [categories addObject:@"All Categories"];
    reviewDictionary = [[NSMutableDictionary alloc] init];
    _merchantNameLabel.text = _currentMerchant.businessname;
    _merchantPhoneNumberLabel.text = _currentMerchant.phone;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedRestaurant
                                                        object:_currentMerchant];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:1];
    //NSLog(@"%@",[formatter  stringFromNumber:_selectedRestaurant.rating]);

    for (UIView *subView in self.searchBar.subviews){
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]]){
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.textColor = [UIColor whiteColor];
                searchBarTextField.font = [UIFont systemFontOfSize:22.0];
                searchBarTextField.tintColor = [UIColor whiteColor];
                searchBarTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search By Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                break;
            }
        }
    }
    
    self.navigationController.toolbar.hidden = TRUE;
    
    [_merchantDescriptionTextView  setText:_currentMerchant.desc];
    [_merchantAddressLabel setText:_currentMerchant.address];
    NSString *opentime = [_currentMerchant.opentime substringToIndex:[_currentMerchant.opentime length]-3];
    NSString *closetime = [_currentMerchant.closetime substringToIndex:[_currentMerchant.closetime length]-3];
    [_merchantHoursLabel setText:[NSString stringWithFormat:@"%@ - %@", opentime, closetime]];
    [_merchantDescriptionTextView setTextColor:[UIColor blackColor]];
    [_merchantDescriptionTextView setFont:[UIFont systemFontOfSize:19.0]];
    _merchantImageView.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _currentMerchant.picture]]];
    _ratingView.backgroundColor = [UIColor lightBackgroundGray];
	_ratingView.layer.cornerRadius = 17.5;
    NSString * rate =[formatter  stringFromNumber:_currentMerchant.rating];

    if ([rate isEqualToString:@".0"]){
        rate = @"N/A";
    }
    _merchantRatingLabel.text = rate;
    
    menuItems = [[NSMutableArray alloc] init];
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    MMUser* userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
    [MMDBFetcher get].delegate = self;
    if ([menuItemDictionary objectForKey:kmenuItems] == nil){
        [[MMDBFetcher get] getMenuWithMerchantId:[_currentMerchant.mid integerValue] withUserEmail:userProfile.email];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    }else{
        menuItems = [menuItemDictionary objectForKey:kmenuItems];
        [self.menuItemsCollectionView reloadData];
    }
    [self.segmentedControl addTarget:self
                           action:@selector(changeReviewSort:)
                 forControlEvents:UIControlEventValueChanged];
    [self.reviewsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
    [self.menuItemsCollectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray * searchItems = [[NSMutableArray alloc] init];
    menuItems = [menuItemDictionary objectForKey:kmenuItems];
    if (!(searchText == nil || [searchText isEqualToString:@""])){
        for (int i = 0; i <menuItems.count; i++){
            MMMenuItem *menuItemName = [menuItems objectAtIndex:i];
            if([[menuItemName.name lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound){
                [searchItems addObject:menuItemName];
            }
        }
        menuItems = [searchItems copy];
    }
    [self.menuItemsCollectionView reloadData];
}


    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        if ([collectionView.restorationIdentifier isEqualToString:@"ReviewCollection"])
            return condensedReviews.count;
        else
            return menuItems.count;
    }
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.restorationIdentifier isEqualToString:@"ReviewCollection"]){
        static NSString *identifier = @"ReviewCell";
        
        MMMenuItemReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        //cell.userInteractionEnabled = YES;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemReviewCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        
        MMMenuItemRating *menitem = [condensedReviews objectAtIndex:indexPath.row];
        UILabel *textReview = (UILabel *) [cell viewWithTag:102];
        UILabel *textName = (UILabel *) [cell viewWithTag:101];
        UILabel * likeLabel = (UILabel *) [cell viewWithTag:108];
        UIView * labelBack = (UIView * ) [cell viewWithTag:106];
        UIImageView * likeImage = (UIImageView *) [cell viewWithTag:107];
        UIImage *image = [UIImage imageNamed:@"upvote"];
        
        if ([menitem.useremail isEqualToString:@"See More Reviews"]){
            textName.text = @"See More Reviews";
            likeLabel.text= @"";
            textReview.text = @"";
            labelBack.backgroundColor = [UIColor whiteColor];
            likeImage.hidden = YES;
        }else{
            // Rounded Corners
            likeImage.hidden = NO;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.contentView.layer.cornerRadius = 5;
            cell.contentView.layer.masksToBounds = YES;
            UILabel * textRating = (UILabel *) [cell viewWithTag:104];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
            [formatter setMaximumFractionDigits:1];
            [formatter setMinimumFractionDigits:1];
            likeLabel.text = [NSString stringWithFormat:@"%@", menitem.likeCount];
            labelBack.backgroundColor = [UIColor lightBackgroundGray];
            labelBack.layer.cornerRadius = 5;
            textRating.text = [formatter  stringFromNumber:menitem.rating];
            textName.text = [NSString stringWithFormat:@"%@ %@", menitem.firstname, menitem.lastname];
            [textReview setText:menitem.review];
            likeImage.image = image;
        }
        cell.rating = menitem;
        return cell;
    }else{
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
        
        MMMenuItem *menitem = [menuItems objectAtIndex:indexPath.row];
        
        UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
        [imageView setImageWithURL:[NSURL URLWithString:menitem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
        // Set the text
        UILabel *textTitle = (UILabel *) [cell viewWithTag:101];
        textTitle.numberOfLines = 2;
        //[textTitle sizeToFit];
        UILabel *textDesc = (UILabel *) [cell viewWithTag:102];
        UILabel * textPrice = (UILabel *) [cell viewWithTag:103];
        UILabel * textRating = (UILabel *) [cell viewWithTag:104];
        UILabel * textMod = (UILabel *) [cell viewWithTag:105];
        UIView * labelBack = (UIView * ) [cell viewWithTag:106];
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
        textPrice.text = [NSString stringWithFormat:@"$%@", [formatterCost  stringFromNumber:menitem.cost]];
        textRating.text = [formatter  stringFromNumber:menitem.rating];
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

    - (void)didRetrieveMenuItems:(NSArray *)menu withResponse:(MMDBFetcherResponse *)response{
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
        else {
            menuItems = menu;
            [menuItemDictionary setObject:menu forKey:kmenuItems];
            for (int i = 0; i<menu.count; i++){
                if(![categories containsObject:[[menu objectAtIndex:i] category]]){
                    [categories addObject:[[menu objectAtIndex:i] category]];
                }
            }
            [[MMDBFetcher get] getItemRatingsMerchantTop:_currentMerchant.mid];
            [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            [self.menuItemsCollectionView reloadData];
        }
        
    }
    
    
// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.restorationIdentifier isEqualToString:@"ReviewCollection"]){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        MMMenuItemReviewCell * itemCell = (MMMenuItemReviewCell *) cell;
        
        touchedReview = [[MMMenuItemRating alloc ]init];
        touchedReview = itemCell.rating;
        
        MMReviewPopOverViewController *categoryContent = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewPopover"];
        // categoryContent.delegate = self;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:categoryContent];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReview object:touchedReview];
        
        //popover.popoverContentSize = CGSizeMake(350, 216);
        popover.delegate = self;
        
        self.popOverController = popover;
        
        // Make sure keyboard is hidden before you show popup.
        [self.searchBar resignFirstResponder];
        
        [self.popOverController presentPopoverFromRect:cell.frame
                                                inView:cell.superview
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    }else{
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        MMMenuItemCell * itemCell = (MMMenuItemCell *) cell;
        NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
        touchedItem = [[MMMenuItem alloc ]init];
        touchedItem = itemCell.menuItem;
        [self performSegueWithIdentifier:@"showMenuItem" sender:self];
    }
    
}

- (void)didRetrieveTopItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response{
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    MMMenuItemRating * rating = [[MMMenuItemRating alloc] init];
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
    }else{
        if (ratings.count != 0){
            allReviews = [ratings mutableCopy];
            if(ratings.count >= 4){
                for (NSInteger w = 0; w<=2; w++){
                    [condensedReviews addObject:[ratings objectAtIndex:w]];
                }
                [condensedReviews addObject:rating];
            }else{
                condensedReviews = [ratings mutableCopy];
                [condensedReviews addObject:rating];
            }
        } else{
            rating.review = @"There are not any reviews available for this dish.";
            [condensedReviews addObject:rating];
            [allReviews addObject:rating];
        }
        [reviewDictionary setObject:allReviews forKey:kAllTopReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedTopReviews];
        [self.reviewsCollectionView reloadData];
    }
    
}
- (void)didRetrieveRecentItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response{
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    MMMenuItemRating * rating = [[MMMenuItemRating alloc] init];
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
    }else{
        if (ratings.count != 0){
            allReviews = [ratings mutableCopy];
            if(ratings.count >= 4){
                for (NSInteger w = 0; w<=2; w++){
                    [condensedReviews addObject:[ratings objectAtIndex:w]];
                }
                [condensedReviews addObject:rating];
            }else{
                condensedReviews = [ratings mutableCopy];
                [condensedReviews addObject:rating];
            }
        } else{
            rating.review = @"There are not any reviews available for this dish.";
            [condensedReviews addObject:rating];
            [allReviews addObject:rating];
        }
        [reviewDictionary setObject:allReviews forKey:kAllRecentReviews];
        [reviewDictionary setObject:condensedReviews forKey:kCondensedRecentReviews];
        [self.reviewsCollectionView reloadData];
    }
    
}

- (void)changeReviewSort:(UISegmentedControl*)control {
    NSMutableArray * reviews = [[NSMutableArray alloc] init];
    switch ([control selectedSegmentIndex]) {
        case 0:
            reviews = [reviewDictionary objectForKey:kCondensedTopReviews];
            if (reviews == nil){
                [[MMDBFetcher get] getItemRatingsMerchantTop:_currentMerchant.mid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            }else
                condensedReviews = reviews;
            
            break;
        case 1:
            reviews = [reviewDictionary objectForKey:kCondensedRecentReviews];
            if (reviews == nil){
                [[MMDBFetcher get] getItemRatingsMerchant:_currentMerchant.mid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            }else
                condensedReviews = reviews;
            break;
        default:
            break;
    }
    [self.reviewsCollectionView reloadData];
}

-(IBAction)categoryPicker:(id)sender{

    MMRestaurantPopOverViewController *categoryContent = [[UIStoryboard restaurantStoryboard] instantiateViewControllerWithIdentifier:@"MenuItemCategoryPopoverViewController"];
    categoryContent.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:categoryContent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCategories object:[categories copy]];
    
    popover.popoverContentSize = CGSizeMake(350, 216);
    popover.delegate = self;
    
    self.popOverController = popover;
    
    // Make sure keyboard is hidden before you show popup.
    [self.searchBar resignFirstResponder];

    [self.popOverController presentPopoverFromRect:self.categoryButton.frame
                                            inView:self.categoryButton.superview
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
}


-(void) didSelectCategory:(NSString *)category{
    NSMutableArray * searchItems = [[NSMutableArray alloc] init];
    menuItems = [menuItemDictionary objectForKey:kmenuItems];
    
    if (![category isEqualToString:@"All Categories"] && category != nil){
        for (int i = 0; i <menuItems.count; i++){
            MMMenuItem *menuItemName = [menuItems objectAtIndex:i];
            if([[menuItemName.category lowercaseString] isEqualToString:[category lowercaseString]]){
                [searchItems addObject:menuItemName];
            }
        }
        menuItems = [searchItems copy];
    }
    
    [self.menuItemsCollectionView reloadData];
    
    [self.popOverController dismissPopoverAnimated:YES];
    
}

-(IBAction)categoryClear:(id)sender{


}
-(IBAction)searchClear:(id)sender{
    for (UIView *subView in self.searchBar.subviews){
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]]){
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                searchBarTextField.text = @"";
                break;
            }
        }
    }
    menuItems = [menuItemDictionary objectForKey:kmenuItems];
    [self.menuItemsCollectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showMenuItem"]){
        MMMenuItemViewController *menuItemController = [segue destinationViewController];
        menuItemController.currentMenuItem = touchedItem;
        menuItemController.currentMerchant = _currentMerchant;
    }
}

- (void)setViews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
