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
#import "UIImage+MMTransform.h"

@interface MMDietaryRestrictionsViewController () {
    NSArray *allAvailableDietaryRestrictions;
    NSMutableArray *usersDietaryRestrictionIDs;
    MMUser *user;
}

@end

@implementation MMDietaryRestrictionsViewController

#pragma mark - View Controller Methods

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

- (void)viewDidAppear:(BOOL)animated {
    [MMDBFetcher get].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getAllRestrictions];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    self.restrictionsCollectionView.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToMainView"]) {
        MMDBFetcher *fetcher = [MMDBFetcher get];
        // Allow destination controller to be delegate now
        fetcher.delegate = [segue destinationViewController];
        if (![[MMLoginManager sharedLoginManager] isUserLoggedIn]) {
            [fetcher addUser:self.userProfile];
            
            NSArray *finalRestrictions = [usersDietaryRestrictionIDs copy];
            [fetcher addUserRestrictions:self.userProfile.email withRestrictionIDs:finalRestrictions];
            
            [[MMLoginManager sharedLoginManager] saveUserProfileToDevice:self.userProfile];
        } else {
            NSArray *finalRestrictions = [usersDietaryRestrictionIDs copy];
            [fetcher addUserRestrictions:user.email withRestrictionIDs:finalRestrictions];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MMDBFetcher Delegate Methods

- (void)didRetrieveUserRestrictions:(NSArray *)userRestrictions withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Communication Error", nil)
                                                          message:NSLocalizedString(@"Unable to communicate with server.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    for (int i = 0; i < userRestrictions.count; i++) {
        [usersDietaryRestrictionIDs addObject:((MMRestriction *) userRestrictions[i]).id];
    }

    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    [self.restrictionsCollectionView reloadData];
}

- (void)didRetrieveAllRestrictions:(NSArray *)restrictions withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Communication Error", nil)
                                                          message:NSLocalizedString(@"Unable to communicate with server.", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    allAvailableDietaryRestrictions = restrictions;

    usersDietaryRestrictionIDs = [[NSMutableArray alloc] init];
    user = [[MMLoginManager sharedLoginManager] getLoggedInUser];

    if (user != nil) {
        [[MMDBFetcher get] getUserRestrictions:user.email];
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        [self.restrictionsCollectionView reloadData];
    }
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return allAvailableDietaryRestrictions.count;
}

//fills the collection view with all of the dietary restrictions available flagging the necessary
//switches to either false or true depending on the current user.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

    MMDietaryRestrictionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    MMRestriction *restriction = [allAvailableDietaryRestrictions objectAtIndex:indexPath.row];

    // Rounded Corners
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.backgroundColor = [UIColor secondaryBlueBar];
    cell.restrictionName.text = restriction.name;
    
    [cell.restrictionImageView setImageWithURL:[NSURL URLWithString:[restriction image]]
                    placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        cell.restrictionImageWithoutMask = [UIImage imageWithImage:image scaledToSize:CGSizeMake(150.0f, 150.0f)];
                        cell.correspondingRestrictionId = restriction.id;
                        
                        cell.isSelected = [usersDietaryRestrictionIDs containsObject:restriction.id];
                    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MMDietaryRestrictionCell *cell = (MMDietaryRestrictionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isSelected = !cell.isSelected;
    
    [self updateUsersDietaryRestrictionsForCell:cell];
}

#pragma mark - Helper Methods

- (void)updateUsersDietaryRestrictionsForCell:(MMDietaryRestrictionCell *)cell {
    if (cell.isSelected) {
        if (![usersDietaryRestrictionIDs containsObject:cell.correspondingRestrictionId])
            [usersDietaryRestrictionIDs addObject:cell.correspondingRestrictionId];
    }
    else {
        [usersDietaryRestrictionIDs removeObject:cell.correspondingRestrictionId];
    }
}

@end
