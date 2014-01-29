//
//  MMDietaryRestrictionsViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMDietaryRestrictionsViewController.h"
#import "UIColor+MyMenuColors.h"
#import <QuartzCore/QuartzCore.h>
#import "MMRestriction.h"
#import "MMDBFetcher.h"

@interface MMDietaryRestrictionsViewController ()



@end
@implementation MMDietaryRestrictionsViewController

// Internal
// Contains All Restrictions
NSArray * allRestrictions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any ad	ional setup after loading the view.
	// Custom initialization
    //NSArray * allRestrictions = [[MMRestriction alloc] init];
    MMDBFetcher * DBFetcher = [[MMDBFetcher alloc] init];
    allRestrictions = DBFetcher.getAllRestrictions;

	
	//restrictions = [NSArray arrayWithObjects:restriction,restriction,restriction, nil];
}

- (void)didReceiveMemoryWarning
{
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
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	
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
	
	
	return cell;
}

@end
