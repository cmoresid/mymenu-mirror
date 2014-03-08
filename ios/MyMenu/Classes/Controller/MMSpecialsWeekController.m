//
//  MMSpecialsPopOverWeek.m
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-02-26.
//
//

#import "MMSpecialsWeekController.h"
#import "UIColor+MyMenuColors.h"

@interface MMSpecialsWeekController ()

@end

@implementation MMSpecialsWeekController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		//[self setSelectedWeek:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGRect frame = self.tableView.frame;
	CGSize size = [self contentSizeForViewInPopover];
	[self.tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeForViewInPopover {
    // Currently no way to obtain the width dynamically before viewWillAppear.
    CGFloat width = 200.0;
    CGRect rect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
    CGFloat height = CGRectGetMaxY(rect);
    return (CGSize){width, height};
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self weeks].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// When loading make sure we know which one should be checkmarked or not
	if(indexPath.item == self.selectedWeek) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	// Set the Proper Text
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EE MMM dd"];
	
	// Get the Date for that section
	NSString *title = [formatter stringFromDate:[self.weeks objectAtIndex:indexPath.item]];
	[cell setTintColor:[UIColor tealColor]];
    [cell.textLabel setText:title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	// If user Selects the item, uncheck it or check it and update the Data model
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSIndexPath * oldPath = [NSIndexPath indexPathForItem:self.selectedWeek inSection:0];
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldPath];
							 
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		self.selectedWeek = indexPath.item;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
		
		[self.specialsCollectionController loadWeek:[self.weeks objectAtIndex:indexPath.item]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
