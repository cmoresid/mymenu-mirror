//
//  MMSpecialsCollectionViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/27/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMSpecialsCollectionViewController.h"
#import "MMSpecial.h"
#import "MMRestriction.h"

@interface MMSpecialsCollectionViewController ()
@property(weak, nonatomic) IBOutlet UISegmentedControl *weekDayButtons;
@end

@implementation MMSpecialsCollectionViewController

// test
NSArray *specials;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // First Time Loading
        NSDate *date = [NSDate date];
        // Get Day of week here
        // Set the button as current
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MMRestriction *restriction = [[MMRestriction alloc] init];
    //[restriction setImage:[UIImage imageNamed:@"rest.jpg"]];
    [restriction setName:@"Drinks"];
    // Use specials type to determine if should be showed for this
    // Type. Next Filter By day of the week.
    //[self specialsType];
    MMSpecial *special = [[MMSpecial alloc] init];
    [special setName:@"Title Goes Here"];
    [special setDesc:@"This is the Description for this item... We should test large ammounts of text.."];
    [special setPicture:@"rest.png"];

    specials = [NSArray arrayWithObjects:special, special, special, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return specials.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    // Rounded Corners

    [cell.contentView setBackgroundColor:[UIColor whiteColor]];

    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;

    MMSpecial *restriction = [specials objectAtIndex:indexPath.row];

    [(UIImageView *) [cell viewWithTag:100] setImage:[UIImage imageNamed:@"rest.jpg"]];

    // Set the Restriction Title
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    UITextView *textDesc = (UITextView *) [cell viewWithTag:102];
    textView.text = restriction.name;
    textDesc.text = restriction.desc;
    [textDesc sizeToFit];


    return cell;
}


// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

@end
