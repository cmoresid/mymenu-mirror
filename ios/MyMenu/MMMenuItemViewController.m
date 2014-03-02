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

#define kCurrentUser @"currentUser"


@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController
NSMutableArray * mods;
NSInteger ratingValue;
MMUser * userProfile;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Delegate method.
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached; //or UIBarPositionTopAttached
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mods = [[NSMutableArray alloc] init];
    self.rating = nil;
    self.reviewField.delegate = self;
    self.navigationBar.delegate = self;
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
    [_itemDescription setFont:[UIFont systemFontOfSize:24.0]];
    _itemImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _touchedItem.picture]]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    _itemRating.text = [formatter stringFromNumber: _touchedItem.rating];
    _itemView.backgroundColor = [UIColor lightBackgroundGray];
	_itemView.layer.cornerRadius = 17.5;
    self.tableView.dataSource = self;
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getModifications:_touchedItem.itemid withUser:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self.tableView reloadData];
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
    kbSize.height = kbSize.height * .35f;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
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



@end
