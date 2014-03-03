//
//  MMSpecialsPopOverTableView.m
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-02-26.
//
//

#import "MMSpecialsPopOverTableView.h"
#import "UIColor+MyMenuColors.h"

@interface MMSpecialsPopOverTableView ()

@end

@implementation MMSpecialsPopOverTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect frame = self.tableView.frame;
	CGSize size = [self preferredContentSize];
	[self.tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
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
    CGFloat width = 150.0;
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
	return [self specialItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setTintColor:[UIColor tealColor]];
	// Get the Type
	NSString * type =[self.specialItems objectAtIndex:indexPath.item];
	
	// When loading make sure we know which one should be checkmarked or not
	if(![self.specialsCollectionController containsShowType:type]) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	// Set the Proper Text
    [cell.textLabel setText:[self.specialItems objectAtIndex:indexPath.item]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	// If user Selects the item, uncheck it or check it and update the Data model
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
		[self.specialsCollectionController addShowType:[cell.textLabel text]];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
		[self.specialsCollectionController removeShowType:[cell.textLabel text]];
        // Reflect deselection in data model
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
