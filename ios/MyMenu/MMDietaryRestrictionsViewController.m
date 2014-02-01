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

#import "MMDietaryRestrictionsViewController.h"
#import "UIColor+MyMenuColors.h"
#import "MMRestriction.h"
#import "MMDBFetcher.h"
#import "MMDietaryRestrictionCell.h"
#import "MMRestrictionSwitch.h"

#define kCurrentUser @"currentUser"

@interface MMDietaryRestrictionsViewController ()

@end

@implementation MMDietaryRestrictionsViewController

NSArray *allRestrictions; // all restrictions
NSMutableArray *dietaryRestrictions; // dietary restrictions


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Initialize
    }

    return self;
}

//loads the view with the dietary restrictions already chosen by the user.
- (void)viewDidLoad {
    [super viewDidLoad];
    allRestrictions = [[MMDBFetcher get] getAllRestrictions];
	[self loadAllImages];
    dietaryRestrictions = [[NSMutableArray alloc] init];
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    NSArray * dietaryRestriction = [[NSArray alloc]init];
    self.userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
	
    if (currentUser != nil) {
        MMDBFetcher *dbFetch = [[MMDBFetcher alloc] init];
        dietaryRestriction = [[dbFetch getUserRestrictions:self.userProfile.email] mutableCopy];
    }
	
    for (int i = 0; i <dietaryRestriction.count; i++){
        [dietaryRestrictions addObject:((MMRestriction *)dietaryRestriction[i]).id];
    }
}


-(void)loadAllImages {
		for(MMRestriction * restriction in allRestrictions) {
			restriction.imageRep = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[restriction image]]]];
		}
}

//Called everytime a switch is turned off or on in this screen.
//It either adds or deletes a restriction from the array.

- (void)switchFlicked:(id)sender {
    MMRestrictionSwitch *restriction = ((MMRestrictionSwitch *) sender);

    if (restriction.on) {
        if (![dietaryRestrictions containsObject:restriction.restId])
            [dietaryRestrictions addObject:restriction.restId];
    } else
        [dietaryRestrictions removeObject:restriction.restId];


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

    [collectionView setBackgroundColor:[UIColor tealColor]];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"%@", cell.contentView.subviews);

    MMRestriction *restriction = [allRestrictions objectAtIndex:indexPath.row];

    UIImageView *recipeImageView = (UIImageView *) [cell viewWithTag:100];
    recipeImageView.image = restriction.imageRep;

    // Set the Restriction Title
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    textView.text = restriction.name;
    MMRestrictionSwitch *restSwitch = (MMRestrictionSwitch *) [cell viewWithTag:102];
    restSwitch.restId = restriction.id;
    if ([dietaryRestrictions containsObject:restriction.id]) {
        restSwitch.on = TRUE;
    } else {
        restSwitch.on = FALSE;
    }

    return cell;
}
//adds to the database and saves the users information in the shared preferences
//only called when the "Done button is pushed
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToMainView"]) {
        MMDBFetcher *fetcher = [MMDBFetcher get];
        [fetcher addUser:self.userProfile];
        NSArray *finalRestrictions = [dietaryRestrictions copy];
        [fetcher addUserRestrictions:self.userProfile.email :finalRestrictions];
        NSUserDefaults * userPreferances = [NSUserDefaults standardUserDefaults];
        NSData * encodedUser = [NSKeyedArchiver archivedDataWithRootObject:self.userProfile];
        [userPreferances setObject:encodedUser forKey:kCurrentUser];
    }
}

@end
