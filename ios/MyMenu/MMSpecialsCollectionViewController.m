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
#import "MMSpecialsCollectionViewController.h"
#import "MMSpecial.h"
#import "MMDBFetcher.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MMSpecialsCollectionViewController ()
@property(weak, nonatomic) IBOutlet UISegmentedControl *weekDayButtons;
@end

@implementation MMSpecialsCollectionViewController

static NSString *days[] = {@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
		[self setSpecialsType:1];
    }

    return self;
}

- (IBAction)dayChanged:(UISegmentedControl *)sender {
    NSUInteger index = (NSUInteger) sender.selectedSegmentIndex;

    if (UISegmentedControlNoSegment != index) {
        NSString *day = days[index];
        NSLog(@"at index, %u, with day %@", index, day);
        [self loadDay:day];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setSpecials:[[NSMutableArray alloc] init]];

	[self setSpecialsType:1];
    NSString *day = [self getToday];

    // find the index that today is at
    int index = -1;
    for (int i = 0; i < 7; i++) {
        if ([[days[i] lowercaseString] isEqualToString:[day lowercaseString]]) {
            index = i;
            break;
        }
    }

    [MMDBFetcher get].delegate = self;
    // initialize specials array to be empty
    // at first for async.
    [[self specials] removeAllObjects];

    // set today as selected
    [self.tabOutlet setSelectedSegmentIndex:index];
    [self loadDay:[self getToday]];
    [self.tabOutlet setTintColor:[UIColor whiteColor]];

}

/**
* Get today as a string, e.g. 'tuesday'
*/
- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [[dateFormatter stringFromDate:[NSDate date]] lowercaseString];
}

/**
* Request specials for a given day. Uses the specialsType defined by the segue
*/
- (void)loadDay:(NSString *)day {
    // Empty out specials array when loading
    // new data so no artifact data remains when
    // switching days.
    [[self specials] removeAllObjects];
    [self.collectionView reloadData];

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [[MMDBFetcher get] getSpecials:day withType:self.specialsType];
}

- (void)didRetrieveSpecials:(NSArray *)webSpecials withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];

    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Unable to retrieve specials."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    [_specials addObject:webSpecials];
    [[self collectionView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self specials] objectAtIndex:section] count];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *headerIdentifier = @"header";
	UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		
		[formatter setDateFormat:@"EEEE MMMM dd"];
		
		NSString *title = [[NSString alloc]initWithFormat:@" %@", [formatter stringFromDate:[NSDate date]]];
		UITextView * textView = (UITextView *) [headerView viewWithTag:99];
        textView.text = title;
        
        reusableview = headerView;
    }
	return reusableview;
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
		
	
    static NSString *identifier = @"Cell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    // Rounded Corners
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;

    MMSpecial *special = [[[self specials] objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];

    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    [imageView setImageWithURL:[NSURL URLWithString:[special picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

    // Set the text
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

	return [self specials].count;
}
@end