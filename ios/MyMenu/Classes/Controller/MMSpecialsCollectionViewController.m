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
#import "MMSpecialsTypeController.h"
#import "MMSpecialsCalendarViewController.h"
#import "UIColor+MyMenuColors.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"

@interface MMSpecialsCollectionViewController () {
    NSArray *types;
}
@property(weak, nonatomic) IBOutlet UISegmentedControl *weekDayButtons;

@end

@implementation MMSpecialsCollectionViewController

static NSString *days[] = {@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"};


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization


    }

    return self;
}

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (BOOL)needsBottomLayoutGuide {
    return FALSE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	//add toolbar to the main view
	[self.toolbar setItems:self.toolbarItems];
	[self.toolbar setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.width, [[UIScreen mainScreen] bounds].size.height, 44)];
    [self.view addSubview:self.toolbar];
	
	// Delegate our self to the db fetcher.
    [MMDBFetcher get].delegate = self;
    self.navigationController.toolbar.hidden = TRUE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupToolbar];
    // Setup the Types we Can filter.
    // These need to be in this order, Food,Drinks,Dessert represent type in the database by 1,2,3.
    types = [NSArray arrayWithObjects:@"Food", @"Drinks", @"Dessert", nil];

    // Set which types we initially show, Default is ALL.
    [self setShowTypes:[NSMutableArray arrayWithObjects:@"Food", @"Drinks", @"Dessert", nil]];

    // Create Array For Holding Specials and the Date Index (Headers)
    [self setSpecials:[[NSMutableDictionary alloc]init]];
	
	[self setDateIndex:[[NSMutableArray alloc] init]];

	// Date at Midnight
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
	
    // Initialize to the current Day
    [self setSelectedDate:date];

    // Delegate our self to the db fetcher.
    [MMDBFetcher get].delegate = self;

    [self loadSelectedDate];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark -
#pragma mark Searchbar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // do the search here and update the view as needed.
    NSLog(@"Search Clicked");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
	
	if(searchText.length == 0) {
		[self setSpecials:[self.specialsSaved mutableCopy]];
	} else {
		[self.specialsSaved enumerateKeysAndObjectsUsingBlock:^(id key, NSArray * array, BOOL *stop) {
			for(MMSpecial * spec in array)
				if([spec.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
				   [spec.desc rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
					if([dict objectForKey:key] != nil) {
						// Add to a previous section
						[[dict objectForKey:key] addObject:spec];
					} else {
						// If we do not have content for the current date create a new "section"
						[dict setObject:[NSMutableArray arrayWithObject:spec] forKey:key];
					}
				}
		}];
		[self setSpecials:dict];
	}
	[[self collectionView] reloadData];
}


#pragma mark -
#pragma mark Toolbar

// Delegate method.
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached; //or UIBarPositionTopAttached
}

/**
 * Sets up the custom toolbar with all buttons, search bar and adds it to the view.
 */
- (void)setupToolbar {
    // Adjust for Toolbar and bottom bar
    [self.collectionView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];

    //create toolbar and set origin and dimensions
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [toolbar setBarTintColor:[UIColor darkTealColor]];
    [toolbar setTintColor:[UIColor whiteColor]];
    [toolbar setDelegate:self];

    //create buttons and set their corresponding selectorsn
    UIBarButtonItem *buttonFilter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter:)];
    UIBarButtonItem *buttonWeek = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStylePlain target:self action:@selector(week:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	
    // Search Bar Creation
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [searchBar setPlaceholder:@"Search..."];
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar setDelegate:self];
    // Put it in a button
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
	
	
	self.labelView = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 300.0f, 21.0f)];
	[self.labelView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[self.labelView setBackgroundColor:[UIColor clearColor]];
	[self.labelView setTextColor:[UIColor whiteColor]];
	//[self.labelView setText:@"Title"];
	[self.labelView setTextAlignment:NSTextAlignmentCenter];
	
	UIBarButtonItem *dateLabel = [[UIBarButtonItem alloc] initWithCustomView:self.labelView];

    // Adjust for right margin
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -18;

    //add buttons to the toolbar
    [self setToolbarItems:[NSArray arrayWithObjects:buttonFilter, buttonWeek, flexibleSpace, dateLabel, flexibleSpace, searchBarButtonItem, negativeSeperator, nil]];
	[self setToolbar:toolbar];
	
}

/**
 * Loads the popover for the user when they click filter
 */
- (void)filter:(UIBarButtonItem *)sender {
    if ([self.typesPopoverController isPopoverVisible]) {
        [self.typesPopoverController dismissPopoverAnimated:YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard specialsStoryboard];
        self.typesController = [storyboard instantiateViewControllerWithIdentifier:@"SpecialsTypes"];

        // Setup view
        [self.typesController setSpecialItems:types];
        [self.typesController setSpecialsCollectionController:self];

        self.typesPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.typesController];

        // Show view
        [self.typesPopoverController setDelegate:self];
        [self.typesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

/**
 * Loads the popover when the user clicks the week button
 */
- (void)week:(UIBarButtonItem *)sender {
    if ([self.weekPopoverController isPopoverVisible]) {
        [self.weekPopoverController dismissPopoverAnimated:YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard specialsStoryboard];
        self.weekController = [storyboard instantiateViewControllerWithIdentifier:@"SpecialsCalendar"];

		//TODO: SET THIS UP WITH CALENDAR

        //[self.weekController setWeeks:weeks];
        //[self.weekController setSelectedWeek:[weeks indexOfObject:self.selectedDate]];
        [self.weekController setSpecialsCollectionController:self];
		
		[self.weekController setSelectedDate:[self selectedDate]];
        self.weekPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.weekController];

        // Show the view using us as delegate
        [self.weekPopoverController setDelegate:self];
        [self.weekPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}


#pragma mark -
#pragma mark Date Functions



/**
* Request specials for a given day. Uses the specialsType defined in the showTypes Array.
*/
- (void)loadSelectedDate {
	
	NSDate * date = self.selectedDate;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE MMM dd"];
	
	// Get the Nearest Sunday, load from there on.
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [comps weekday];
	NSDate *lastSunday = [date dateByAddingTimeInterval:-3600*24*(weekday-1)];
	
	// Display the Date in the toolbar
    NSMutableString *title = [[formatter stringFromDate:lastSunday] mutableCopy];
	[title appendFormat:@" - %@",[formatter stringFromDate:[self getDate:lastSunday PlusDays:6]]];
	[self.labelView setText:title];
	
	// If we are displaying the page already don't reload.
	if([self.dateIndex containsObject:self.selectedDate])  {
		return;
	}
	
	[self.dateIndex removeAllObjects];
	
	for(int i = 0; i < 7; i++) {
		[self.dateIndex addObject: [self getDate:lastSunday PlusDays:i]];
	}
	
    // Refresh the View
    [self.collectionView reloadData];
	
	for(NSDate * date in self.dateIndex) {
		
		if([self.specials objectForKey:date] != nil) {
			[[self.specials objectForKey:date] removeAllObjects];
		}
		
		[self loadDay:date];
	}
	
	NSLog(@"%@",[NSIndexPath indexPathForRow:0 inSection:[self.dateIndex indexOfObject:date]]);
	
    // TODO: display message no options selected?
}

/**
 * Request specials for a given day, with a Given Type
 */
- (void)loadDay:(NSDate *)date {
	
    // Show Indicator
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
    // Check for which type we need, and if it is the showTypes array.
    if ([self.showTypes containsObject:@"Food"])
        [[MMDBFetcher get] getFoodSpecialsForDate:date];
	
    if ([self.showTypes containsObject:@"Drinks"])
        [[MMDBFetcher get] getDrinkSpecialsForDate:date];
	
    if ([self.showTypes containsObject:@"Dessert"])
        [[MMDBFetcher get] getDessertSpecialsForDate:date];
	
	
    // Safety check if no type is selected, we need to close the loading
    if (self.showTypes.count == 0)
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
	
	
	
    // TODO: display message no options selected?
}


/**
 * Request specials for a given day, with a Given Type
 */
- (void)loadDate:(NSDate *)date forType:(NSString *)type {

    // Show Indicator
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

    // Check for which type we need, and if it is the showTypes array.
    if ([self.showTypes containsObject:@"Food"] && [type isEqualToString:@"Food"])
        [[MMDBFetcher get] getFoodSpecialsForDate:date];

    if ([self.showTypes containsObject:@"Drinks"] && [type isEqualToString:@"Drinks"])
        [[MMDBFetcher get] getDrinkSpecialsForDate:date];

    if ([self.showTypes containsObject:@"Dessert"] && [type isEqualToString:@"Dessert"])
        [[MMDBFetcher get] getDessertSpecialsForDate:date];


    // Safety check if no type is selected, we need to close the loading
    if (self.showTypes.count == 0)
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
	
	

    // TODO: display message no options selected?
}


/**
 * Returns a New Date from the current date + the number of days specified.
 */
- (NSDate *)getCurrentDatePlusDays:(NSUInteger)days {
    return [self.currentDate dateByAddingTimeInterval:60 * 60 * 24 * days];
}


/**
 * Returns a New Date from the date specified + the number of days specified.
 */
- (NSDate *)getDate:(NSDate *)date PlusDays:(NSUInteger)days {
    return [date dateByAddingTimeInterval:60 * 60 * 24 * days];
}


#pragma mark -
#pragma mark DBFetcherDelegate Methods
/**
 * The DBFetcher Sends our info here. We need the date to place it accordingly.
 */
- (void)didRetrieveSpecials:(NSArray *)webSpecials forDate:(NSDate *)date withResponse:(MMDBFetcherResponse *)response {
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];

    // If there is some error show it.
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Unable to retrieve specials."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }

    // Check that the query returned something
	//TODO: Check if date is within the selected date range...
    if (webSpecials.count > 0 && [self.dateIndex containsObject:date]) {
		//[self.specials addObjectsFromArray:[webSpecials mutableCopy]];
        
       // NSUInteger index = [self.dateIndex indexOfObject:date];
        if([self.specials objectForKey:date] != nil) {
            // Add to a previous section
            [[self.specials objectForKey:date] addObjectsFromArray:webSpecials];
        } else {
            // If we do not have content for the current date create a new "section"
            [self.specials setObject:[webSpecials mutableCopy] forKey:date];
		}
	}
	
	[self setSpecialsSaved:[self.specials copy]];
	
    // Reload the View
    [[self collectionView] reloadData];
	
}

#pragma mark -
#pragma mark Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.dateIndex.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIView * innerView = [cell viewWithTag:22];
    // Rounded Corners
    innerView.layer.cornerRadius = 5;
    innerView.layer.masksToBounds = YES;
	innerView.layer.borderColor = [UIColor whiteColor].CGColor;
	innerView.layer.borderWidth = 2;
	
	// Add Shadow
	cell.layer.masksToBounds = NO;
	cell.layer.shadowOffset = CGSizeZero;
	cell.layer.shadowColor = [UIColor blackColor].CGColor;
	cell.layer.shadowOpacity = 0.4f;
	cell.layer.shadowRadius = 5.0f;
	cell.layer.shadowOffset = CGSizeZero;
	cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
	
    // Get the Special
    MMSpecial *special = [[self.specials objectForKey:[self.dateIndex objectAtIndex:indexPath.section]] objectAtIndex:indexPath.item];

    // Load the Image in
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    [imageView setImageWithURL:[NSURL URLWithString:[special picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

    // Set the text
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    UITextView *textDesc = (UITextView *) [cell viewWithTag:102];
    textView.text = special.name;
    textDesc.text = special.desc;
    //[textDesc sizeToFit];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	
	// Get the HeaderView
	static NSString *headerIdentifier = @"header";
	UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
		// Format for Header Date
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"EEEE MMMM dd"];
		
		// Get the Date for that section
		NSString *title = [formatter stringFromDate:[self.dateIndex objectAtIndex:indexPath.section]];
		
		// Get View and set
		UITextView * textView = (UITextView *) [headerView viewWithTag:99];
		textView.text = title;
		
		// Return the setupview
		reusableview = headerView;
    }
	return reusableview;
	
}


// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSArray * sectionArray = [self.specials objectForKey:[self.dateIndex objectAtIndex:section]];
	return sectionArray.count;
}

#pragma mark - 
#pragma mark Show Type Functions

/**
 * Removes a particular ShowType and updates the Collection View As needed.
 */
- (void)removeShowType:(NSString *)type {
    [[self showTypes] removeObject:type];
    NSUInteger categoryId = [types indexOfObject:type];
	
	for(NSDate * date in self.dateIndex) {
		// Section
		NSMutableArray *currentDateIndexArray = [self.specials objectForKey:date];
		
		// Set of Items needing to be removed
		NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
		int i = 0;
		
		// Check all the specials for this date if they are of the same type.
		for (MMSpecial *special in currentDateIndexArray) {
			if (([[special categoryid] unsignedIntegerValue] - 1) == categoryId) {
				[set addIndex:i];
			}
			i++;
		}
		
		// Remove all of the same type
		[currentDateIndexArray removeObjectsAtIndexes:set];
		[set removeAllIndexes];
		
	}
    // Refresh the view
    [self.collectionView reloadData];
}

/**
 * Adds a show type and updates the view as needed
 */

- (void)addShowType:(NSString *)type {
    // Check if the Type is there or not
    if (![self containsShowType:type]) {

        // If it is not add it.
        [[self showTypes] addObject:type];

        // Reload all the dates for the type added, since it will be removed at this time.
		for(NSDate * date in self.dateIndex)
			[self loadDate:date forType:type];
		
        // Refresh View
        [self.collectionView reloadData];
    }
}

/**
 * Check if the view is showing a type
 */
- (bool)containsShowType:(NSString *)type {
    if (![self.showTypes containsObject:type]) {
        return false;
    }
    return true;
}

#pragma mark -
#pragma mark Other

/**
 * Prepares for the popup window, sets up the proper types needed.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id popover = segue.destinationViewController;
    if ([popover isKindOfClass:[MMSpecialsTypeController class]]) {

        popover = (MMSpecialsTypeController *) popover;
        [popover setSpecialItems:types];
        [popover setSpecialsCollectionController:self];

    } else if ([popover isKindOfClass:[MMSpecialsCalendarViewController class]]) {

        popover = (MMSpecialsCalendarViewController *) popover;
       /* NSMutableArray *weeks = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            [weeks addObject:[self getCurrentDatePlusDays:i * 7]];
        }
        [popover setWeeks:weeks];
        [popover setSelectedWeek:[weeks indexOfObject:self.selectedDate]];
        [popover setSpecialsCollectionController:self];*/
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end