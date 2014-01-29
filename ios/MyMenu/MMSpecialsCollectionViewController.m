//
//  MMSpecialsCollectionViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/27/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMSpecialsCollectionViewController.h"
#import "MMRestriction.h"
#import "UIColor+MyMenuColors.h"
@interface MMSpecialsCollectionViewController ()

@end



@implementation MMSpecialsCollectionViewController

// test
NSArray * restrictions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MMRestriction *restriction = [[MMRestriction alloc] init];
	//[restriction setImage:[UIImage imageNamed:@"rest.jpg"]];
	[restriction setName:@"Drinks"];
	
	restrictions = [NSArray arrayWithObjects:restriction,restriction,restriction, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return restrictions.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"Cell";
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	
	// Rounded Corners

	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	cell.contentView.layer.cornerRadius = 5;
	cell.contentView.layer.masksToBounds = YES;
	
	MMRestriction * restriction = [restrictions objectAtIndex:indexPath.row];
	
	[cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[restriction image]]];
	
	// Set the Restriction Title
	UITextView * textView = (UITextView *) [cell viewWithTag:101];
	textView.text = restriction.name;
	
	
	return cell;
}


// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

@end
