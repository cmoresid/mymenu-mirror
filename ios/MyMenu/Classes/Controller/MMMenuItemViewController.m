//
//  MMMenuItemViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-11.
//
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

#define kCondensedTopReviews @"condensedTopReviews"
#define kCondensedRecentReviews @"condensedRecentReviews"
#define kAllRecentReviews @"allRecentReviews"
#define kAllTopReviews @"allTopReviews"
#define kReview @"kReview"


@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController


NSMutableArray * mods;
NSInteger ratingValue;
MMUser * userProfile;
NSMutableArray * condensedReviews;
NSMutableArray * allReviews;
NSMutableDictionary *reviewDictionary;
MMMenuItemRating * touchedItem;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    userProfile = [[MMUser alloc] init];
    reviewDictionary = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
    mods = [[NSMutableArray alloc] init];
    self.rating = nil;
    self.reviewField.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Register for keyboard notifications to allow
    // for view to scroll to text field
    [self registerForKeyboardNotifications];
    [[self.reviewField layer] setBorderColor:[[UIColor tealColor] CGColor]];
    [[self.reviewField layer] setBorderWidth:2.3];
    [[self.reviewField layer] setCornerRadius:5];
    [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ratingButton setTitle:@"Rate This Item"  forState:UIControlStateNormal];
    _itemName.text = _touchedItem.name;
    _itemDescription.text = _touchedItem.desc;
    [_itemDescription setTextColor:[UIColor blackColor]];
    [_itemDescription setFont:[UIFont systemFontOfSize:19.0]];
    _itemImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _touchedItem.picture]]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    _itemRating.text = [formatter stringFromNumber: _touchedItem.rating];
    _itemView.backgroundColor = [UIColor lightBackgroundGray];
	_itemView.layer.cornerRadius = 17.5;
    self.tableView.dataSource = self;
    userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getModifications:_touchedItem.itemid withUser:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
        [self.collectionView registerNib:[UINib nibWithNibName:@"MenuItemReviewCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewCell"];
    [self.reviewSegment addTarget:self
                                   action:@selector(changeReviewSort:)
                         forControlEvents:UIControlEventValueChanged];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    if([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]){

        _eatenThisButton.enabled = NO;
        _eatenThisButton.backgroundColor = [UIColor lightGrayColor];
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
        [self.collectionView reloadData];
        [[MMDBFetcher get] eatenThis:userProfile.email withMenuItem:_touchedItem.itemid withMerch:_touchedItem.merchid];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
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
        [self.collectionView reloadData];
    }
    
}

-(void) didRetrieveModifications:(NSArray *)modificationsArray withResponse:(MMDBFetcherResponse *)response{
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }else{
        if (modificationsArray.count != 0){
            mods = [modificationsArray mutableCopy];
        } else{
            [mods addObject:@"There are not any modifications available for this dish."];
        }
        [self.tableView reloadData];
    }
    [[MMDBFetcher get] getItemRatingsTop:_touchedItem.itemid];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}




#pragma mark - Table View
// Theres only one section in this view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Return the amount of restaurants.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSString * modification = [mods objectAtIndex: indexPath.row];

    UITextView *modificationView = (UITextView *) [cell viewWithTag:500];
    [modificationView setFont:[UIFont systemFontOfSize:30.0]];
    modificationView.text = modification;
    
    return cell;
}

-(BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return FALSE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// If a text field is not visible, move the content view
// using an animation to bring the text field into view by
// scrolling the content view.
- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //float copyHeight = kbSize.height /2.0f;
    kbSize.height = kbSize.height *0.1f;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGRect bRect = self.activeField.frame;
    
    bRect.origin.y += 300;
    
    if (CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
    
        [self.scrollView scrollRectToVisible:bRect animated:YES];
    }
}

// Reset the scroll view to the default location when the
// keyboard is hidden.
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Set the reference to the text field that should be
// focused on.
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Please enter your review here..."]){
        textView.text = @"";
    }
    self.activeField = textView;
}

// Remove the reference to the active textfield.
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeField = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"backToRestPage"]){
        MMRestaurantViewController *restaurantController = [segue destinationViewController];
        restaurantController.selectedRestaurant = _selectedRestaurant;
        
    }
}

- (IBAction)shareViaFacebook:(id)sender {
    SLComposeViewController *controller = [MMSocialMediaService shareMenuItem:self.touchedItem withService:SLServiceTypeFacebook];
    
    if (controller) {
        [self presentViewController:controller animated:TRUE completion:nil];
    }
}

- (IBAction)shareViaTwitter:(id)sender {
    SLComposeViewController *controller = [MMSocialMediaService shareMenuItem:self.touchedItem withService:SLServiceTypeTwitter];
    
    if (controller) {
        [self presentViewController:controller animated:TRUE completion:nil];
    }
}

- (IBAction)ratingButton:(id)sender{
    MMRatingPopoverViewController *ratingPop = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuItemRatingPopover"];
    
    ratingPop.menuItem = self.touchedItem;
    ratingPop.menuRestaurant = self.selectedRestaurant;
    
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
    [self.reviewField resignFirstResponder];
    
    [self.popOverController presentPopoverFromRect:self.ratingButton.frame
                                                    inView:self.ratingButton.superview
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
    
}


-(void)didCreateRating:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
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
    if (successful == FALSE){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Your Review did not send.  Please check your internet connection and try again."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
            return;
    } else {
        self.reviewField.text = @"Please enter your review here...";
        [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Rate This Item"] forState:UIControlStateNormal];
        [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
        

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return condensedReviews.count;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    MMMenuItemReviewCell * itemCell = (MMMenuItemReviewCell *) cell;
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    touchedItem = [[MMMenuItemRating alloc ]init];
    touchedItem = itemCell.rating;
   
    MMReviewPopOverViewController *reviewContent = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewPopover"];
    reviewContent.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:reviewContent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReview object:touchedItem];
    
    //popover.popoverContentSize = CGSizeMake(350, 216);
    popover.delegate = self;
    
    self.popOverController = popover;
    
    // Make sure keyboard is hidden before you show popup.
    [self.reviewField resignFirstResponder];
    
    [self.popOverController presentPopoverFromRect:cell.frame
                                            inView:cell.superview
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    
   // [self performSegueWithIdentifier:@"showMenuItem" sender:self];
    
}
- (void)didUserEat:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }else if(exists)
        _eatenThisButton.enabled = NO;
        
}

- (void)didSelectDone:(BOOL)done{
    [MMDBFetcher get].delegate = self;
    [self.popOverController dismissPopoverAnimated:YES];
    
    
}

- (void)didSelectCancel:(BOOL)cancel{
    [MMDBFetcher get].delegate = self;
    [self.popOverController dismissPopoverAnimated:YES];
    
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
    UILabel * likeLabel = (UILabel *) [cell viewWithTag:108];
    UIView * labelBack = (UIView * ) [cell viewWithTag:106];
    UIImageView * likeImage = (UIImageView *) [cell viewWithTag:107];
    UIImage *image = [UIImage imageNamed:@"upvote"];

    if (menitem.id == [NSNumber numberWithInt:-1]){
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
}

- (void)changeReviewSort:(UISegmentedControl*)control {
    NSMutableArray * reviews = [[NSMutableArray alloc] init];
    switch ([control selectedSegmentIndex]) {
        case 0:
            reviews = [reviewDictionary objectForKey:kCondensedTopReviews];
            if (reviews == nil){
                [[MMDBFetcher get] getItemRatingsTop:_touchedItem.itemid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            }else
                condensedReviews = reviews;
            
            break;
        case 1:
            reviews = [reviewDictionary objectForKey:kCondensedRecentReviews];
            if (reviews == nil){
                [[MMDBFetcher get] getItemRatings:_touchedItem.itemid];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
            }else
                condensedReviews = reviews;
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}

- (IBAction)saveButton:(id)sender{
    MMMenuItemRating *currentRating = [[MMMenuItemRating alloc] init];
    currentRating.rating = [NSNumber numberWithInteger:ratingValue];
    if ((self.reviewField.text == nil || [self.reviewField.text isEqualToString:@""]) || [self.reviewField.text isEqualToString:@"Please enter your review here..."]){
        
        currentRating.review = @"";
    } else {
        currentRating.review = self.reviewField.text;
    }
    currentRating.menuid = self.touchedItem.itemid;
    currentRating.merchid = self.selectedRestaurant.mid;
    currentRating.useremail = userProfile.email;
    [[MMDBFetcher get] addMenuRating:currentRating];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}

- (IBAction)clearButton:(id)sender{
    self.reviewField.text = @"Please enter your review here...";
    self.rating = nil;
    [self.ratingButton setTitle:[[NSString alloc] initWithFormat:@"Rate This Item"] forState:UIControlStateNormal];
    [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) didAddEatenThis:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response{
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
    else if (succesful){
        _eatenThisButton.enabled = NO;
        _eatenThisButton.backgroundColor = [UIColor lightBackgroundGray];
    }
}

- (IBAction)iveEatenThis:(id)sender{
     _eatenThisButton.enabled = NO;
    _eatenThisButton.backgroundColor = [UIColor lightBackgroundGray];
    [[MMDBFetcher get] eatenThis:userProfile.email withMenuItem:_touchedItem.itemid withMerch:_touchedItem.merchid];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
   
    
}

@end
