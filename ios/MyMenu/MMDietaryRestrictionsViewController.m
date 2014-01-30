//
//  MMDietaryRestrictionsViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMDietaryRestrictionsViewController.h"
#import "UIColor+MyMenuColors.h"
#import "MMRestriction.h"
#import "MMDBFetcher.h"
#import "MMDietaryRestrictionCell.h"
#import "MMRestrictionSwitch.h"

@interface MMDietaryRestrictionsViewController ()


@end

@implementation MMDietaryRestrictionsViewController

// Internal
// Contains All Restrictions
NSArray * allRestrictions;
NSMutableArray* dietaryRestrictions;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    MMDBFetcher * DBFetcher = [[MMDBFetcher alloc] init];

    allRestrictions = DBFetcher.getAllRestrictions;
    dietaryRestrictions= [[NSMutableArray alloc] init];

}
/*
 Called everytime a switch is turned off or on in this screen
 it either adds or deletes a restriction from the array
 */
-(void) switchFlicked:(id)sender{

    MMRestrictionSwitch* restriction = ((MMRestrictionSwitch*)sender);
    
    if (restriction.on) {
        if(![dietaryRestrictions containsObject:restriction.restId])
            [dietaryRestrictions addObject:restriction.restId];
    }else
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"Cell";
	
	MMDietaryRestrictionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.onSwitch addTarget:self action:@selector(switchFlicked:) forControlEvents:UIControlEventValueChanged];
	
	// Rounded Corners
	cell.contentView.layer.cornerRadius = 20;
	cell.contentView.layer.masksToBounds = YES;
	
	[collectionView setBackgroundColor:[UIColor tealColor]];
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	NSLog(@"%@",cell.contentView.subviews);
	
	MMRestriction * restriction = [allRestrictions objectAtIndex:indexPath.row];
	
	UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    UIImage * myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[restriction image]]]];
	recipeImageView.image = myImage;
	
	// Set the Restriction Title
	UITextView * textView = (UITextView *) [cell viewWithTag:101];
	textView.text = restriction.name;
    MMRestrictionSwitch * restSwitch = (MMRestrictionSwitch *) [cell viewWithTag:102];
    restSwitch.restId = restriction.id;
    if ([dietaryRestrictions containsObject:restriction.id]){
        restSwitch.on = TRUE;
    }else{
        restSwitch.on = FALSE;
    }
	
	return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToMainView"]) {
        MMDBFetcher * dbFetcher = [[MMDBFetcher alloc] init];
        [dbFetcher addUser:self.userProfile];
        NSArray * finalRestrictions = [dietaryRestrictions copy];
        [dbFetcher addUserRestrictions:self.userProfile.email:finalRestrictions];
        

    }
}


@end
