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
#define kCurrentUser @"currentUser"


@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController
NSMutableArray * mods;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mods = [[NSMutableArray alloc] init];
    _itemName.text = _touchedItem.name;
    _itemDescription.text = _touchedItem.desc;
    [_itemDescription setTextColor:[UIColor blackColor]];
    [_itemDescription setFont:[UIFont systemFontOfSize:24.0]];
    _itemImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _touchedItem.picture]]];
    _itemView.backgroundColor = [UIColor lightBackgroundGray];
	_itemView.layer.cornerRadius = 17.5;
    self.tableView.dataSource = self;
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    MMUser* userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
