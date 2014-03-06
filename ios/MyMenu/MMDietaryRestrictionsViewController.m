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

#import <MBProgressHUD/MBProgressHUD.h>
#import "MMDietaryRestrictionsViewController.h"
#import "UIColor+MyMenuColors.h"
#import "MMRestriction.h"
#import "MMDBFetcher.h"
#import "MMDietaryRestrictionCell.h"
#import "MMRestrictionSwitch.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMLoginManager.h"

#define kCurrentUser @"currentUser"

@interface MMDietaryRestrictionsViewController ()

@end

@implementation MMDietaryRestrictionsViewController

NSArray *allRestrictions; // all restrictions
NSMutableArray *dietaryRestrictionIds; // dietary restrictions
MMUser * user;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Initialize
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
        [[MMLoginManager sharedLoginManager] logoutUser];
        [self performSegueWithIdentifier:@"userMustLogin" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [MMDBFetcher get].delegate = self;
}

//will be used in the future.....
//TODO: use this method.
-(void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
    
}
//loads the view with the dietary restrictions already chosen by the user.
- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[MMUser alloc]init];
    // Load all restrictions.
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getAllRestrictions];

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}

- (void)didRetrieveUserRestrictions:(NSArray *)userRestrictions withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    for (int i = 0; i < userRestrictions.count; i++) {
        [dietaryRestrictionIds addObject:((MMRestriction *) userRestrictions[i]).id];
    }

    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    [self.collectionView reloadData];
}

- (void)didRetrieveAllRestrictions:(NSArray *)restrictions withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    allRestrictions = restrictions;

    // TODO: Remove this in a little bit
    //[self loadAllImages];

    dietaryRestrictionIds = [[NSMutableArray alloc] init];
    user = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    if (user.email != nil) {
        [[MMDBFetcher get] getUserRestrictions:user.email];
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        [self.collectionView reloadData];
    }
}

//Called everytime a switch is turned off or on in this screen.
//It either adds or deletes a restriction from the array.

- (void)switchFlicked:(id)sender {
    MMRestrictionSwitch *restriction = ((MMRestrictionSwitch *) sender);

    if (restriction.on) {
        if (![dietaryRestrictionIds containsObject:restriction.restId])
            [dietaryRestrictionIds addObject:restriction.restId];
    } else
        [dietaryRestrictionIds removeObject:restriction.restId];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return allRestrictions.count;
}

//fills the collection view with all of the dietary restrictions available flagging the necessary
//switches to either false or true depending on the current user.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

    MMDietaryRestrictionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.onSwitch addTarget:self action:@selector(switchFlicked:) forControlEvents:UIControlEventValueChanged];

    // Rounded Corners
    cell.contentView.layer.cornerRadius = 20;
    cell.contentView.layer.masksToBounds = YES;

    [cell.contentView setBackgroundColor:[UIColor secondaryBlueBar]];

    MMRestriction *restriction = [allRestrictions objectAtIndex:indexPath.row];

    UIImageView *recipeImageView = (UIImageView *) [cell viewWithTag:100];
    [recipeImageView setImageWithURL:[NSURL URLWithString:[restriction image]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

    // Set the Restriction Title
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    textView.text = restriction.name;

    MMRestrictionSwitch *restSwitch = (MMRestrictionSwitch *) [cell viewWithTag:102];
    restSwitch.restId = restriction.id;
    restSwitch.on = ([dietaryRestrictionIds containsObject:restriction.id]);

    return cell;
}

//adds to the database and saves the users information in the shared preferences
//only called when the "Done button is pusheda
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToMainView"]) {
        MMDBFetcher *fetcher = [MMDBFetcher get];
        // Allow destination controller to be delegate now
        fetcher.delegate = [segue destinationViewController];
        if (user.email == nil){
            [fetcher addUser:self.userProfile];

            NSArray *finalRestrictions = [dietaryRestrictionIds copy];
            [fetcher addUserRestrictions:self.userProfile.email :finalRestrictions];
            
            [[MMLoginManager sharedLoginManager] saveUserProfileToDevice:self.userProfile];
        } else  {
            NSArray *finalRestrictions = [dietaryRestrictionIds copy];
            [fetcher addUserRestrictions:user.email :finalRestrictions];
        }
    }
}

@end
