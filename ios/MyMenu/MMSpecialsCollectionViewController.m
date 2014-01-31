//
//  MMSpecialsCollectionViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/27/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMSpecialsCollectionViewController.h"
#import "MMSpecial.h"
#import "MMDBFetcher.h"

@interface MMSpecialsCollectionViewController ()
@property(weak, nonatomic) IBOutlet UISegmentedControl *weekDayButtons;
@end

@implementation MMSpecialsCollectionViewController

NSArray *specials;
static NSString *days[] = {@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }

    return self;
}

- (IBAction)dayChanged:(UISegmentedControl *)sender {
    NSUInteger index = (NSUInteger) sender.selectedSegmentIndex;

    if (UISegmentedControlNoSegment != index) {
        NSString *day = days[index];
        NSLog(@"at index, %u, with day %@", index, day);
        [self loadDay:day];
        [[self collectionView] reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *day = [self getToday];
    int index;

    for (int i = 0; i < 7; i++) {
        if ([[days[i] lowercaseString] isEqualToString:[day lowercaseString]]) {
            index = i;
            NSLog(@"today is at index %d", index);
            break;
        }
    }

    [self.tabOutlet setSelectedSegmentIndex:index];
    [self loadDay:[self getToday]];
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [[dateFormatter stringFromDate:[NSDate date]] lowercaseString];
}

- (void)loadDay:(NSString *)day {
    specials = [[MMDBFetcher get] getSpecials:day :self.specialsType];
    NSLog(@"got %d specials for %@ with type %d.", specials.count, day, self.specialsType);
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

    MMSpecial *special = [specials objectAtIndex:indexPath.row];
    UIImage *myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:special.picture]]];

    [(UIImageView *) [cell viewWithTag:100] setImage:myImage];

    // Set the Restriction Title
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    UITextView *textDesc = (UITextView *) [cell viewWithTag:102];
    textView.text = special.name;
    textDesc.text = special.desc;
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
