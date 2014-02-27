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
#import "MMSpecialsPopOverTableView.h"

@interface MMSpecialsCollectionViewController () {
	NSArray const * types;
}
	@property(weak, nonatomic) IBOutlet UISegmentedControl *weekDayButtons;

@end

@implementation MMSpecialsCollectionViewController

static NSString *days[] = {@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"};



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
		types = [NSArray arrayWithObjects:@"Food",@"Drinks",@"Dessert", nil];
		[self setShowTypes:[NSMutableArray arrayWithObjects:@"Food",@"Drinks",@"Dessert", nil]];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	types = [NSArray arrayWithObjects:@"Food",@"Drinks",@"Dessert", nil];
	[self setSpecials:[[NSMutableArray alloc] init]];
	[self setShowTypes:[NSMutableArray arrayWithObjects:@"Food",@"Drinks",@"Dessert", nil]];
	[self setDateIndex:[[NSMutableArray alloc]init]];
	// Initialize to the current Day
	[self setCurrentDate:[NSDate date]];

    [MMDBFetcher get].delegate = self;
    // initialize specials array to be empty
    // at first for async.
    [[self specials] removeAllObjects];
	

    // set today as selected
	[self loadDate:self.currentDate];
	[self loadDate:[self getCurrentDatePlusDays:1]];
	[self loadDate:[self getCurrentDatePlusDays:2]];
	[self loadDate:[self getCurrentDatePlusDays:3]];
	[self loadDate:[self getCurrentDatePlusDays:4]];

}

/**
* Get today as a string, e.g. 'tuesday'
*/
- (NSString *)getDay{
	
	NSDate * date = [self currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [[dateFormatter stringFromDate:date] lowercaseString];
}

/**
* Request specials for a given day. Uses the specialsType defined by the segue
*/
- (void)loadDate:(NSDate *) date {
    // Empty out specials array when loading
    // new data so no artifact data remains when
    // switching days.
	NSUInteger index = [self indexOfDate:date];
    if(index != -1) {
		[[self.specials objectAtIndex:index] removeAllObjects];
	}
	
    [self.collectionView reloadData];

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	if([self.showTypes containsObject:@"Food"])
		[[MMDBFetcher get] getFoodSpecials:[self getDay] withDate:date];
	
	if([self.showTypes containsObject:@"Drinks"])
		[[MMDBFetcher get] getDrinkSpecials:[self getDay] withDate:date];
	
	if([self.showTypes containsObject:@"Dessert"])
		[[MMDBFetcher get] getDessertSpecials:[self getDay] withDate:date];
	
	if(self.showTypes.count == 0)
		[MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
	
	// TODO: display message no options selected?
}

- (void)didRetrieveSpecials:(NSArray *)webSpecials forDate:(NSDate *)date withResponse:(MMDBFetcherResponse *)response {
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

	if(webSpecials.count > 0) {
		int index = [self indexOfDate:date];
		if(index != -1) {
			[[self.specials objectAtIndex:index] addObjectsFromArray:webSpecials];
		} else {
			[self.dateIndex addObject:date];
			[self.specials addObject:webSpecials];
		}
		[[self collectionView] reloadData];
	}
}

// returns -1 if it doesn't exist.
-(int)indexOfDate:(NSDate *) date {
	int i = 0;
	for (NSDate * dateIndex in self.dateIndex) {
		if([dateIndex isEqualToDate:date]) {
			return i;
		}
		i++;
	}
	return -1;
}

// Adds one day to the current date
-(NSDate *) getCurrentDatePlusDays: (NSUInteger) days {
	NSLog(@"%@",[self.currentDate dateByAddingTimeInterval:60*60*24*days]);
	return [self.currentDate dateByAddingTimeInterval:60*60*24*days];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [[self.specials objectAtIndex:section] count];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *headerIdentifier = @"header";
	UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		
		[formatter setDateFormat:@"EEEE MMMM dd"];
		
		NSString *title = [formatter stringFromDate:[self.dateIndex objectAtIndex:indexPath.section]];
		UITextView * textView = (UITextView *) [headerView viewWithTag:99];
		textView.text = title;
		reusableview = headerView;
    }
	return reusableview;
	
}

-(void)removeShowType:(NSString *) type {
	[[self showTypes] removeObject:type];
	
	NSUInteger categoryId = [types indexOfObject:type];
	
	int currentDateIndex = 0;
	
	// We don't need to reload since we are removing things...
	for (NSDate * date in self.dateIndex) {
		NSMutableArray * currentDateIndexArray = [self.specials objectAtIndex:currentDateIndex];
		NSMutableIndexSet * set = [[NSMutableIndexSet alloc] init];
		int i = 0;
		for (MMSpecial * special in currentDateIndexArray) {
			if (([[special categoryid] unsignedIntegerValue]-1) == categoryId) {
				[set addIndex:i];
			}
			i++;
		}
		[currentDateIndexArray removeObjectsAtIndexes:set];
		[set removeAllIndexes];
		
		currentDateIndex++;
	}
	[self.collectionView reloadData];
}

-(void)addShowType:(NSString *) type {
	if(![self.showTypes containsObject:type]) {
		[[self showTypes] addObject:type];
		for (NSDate * date in self.dateIndex) {
			[self loadDate:date];
		}
		[self.collectionView reloadData];
	}
}

-(bool)containsShowType:(NSString *)type {
	if(![self.showTypes containsObject:type]) {
		return false;
	}
	return true;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    // Rounded Corners
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;

	MMSpecial *special = [[self.specials objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
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
	return self.dateIndex.count;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	MMSpecialsPopOverTableView * popover = segue.destinationViewController;
	[popover setSpecialItems:types];
	[popover setSpecialsCollectionController:self];
	
	//[[popover.contentViewController.childViewControllers objectAtIndex:0] setSpecialItems:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]];
}
@end