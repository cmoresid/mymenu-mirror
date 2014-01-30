//
//  MMMasterViewController.m
//  Master
//
//  Created by Chris Pavlicek on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMMasterViewController.h"
#import "RestaurantCell.h"
#import "MMDetailViewController.h"
#import "MMDBFetcher.h"

@interface MMMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MMMasterViewController

- (void)awakeFromNib {
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    MMDBFetcher *Dbfetcher = [[MMDBFetcher alloc] init];
    _restaurants = [Dbfetcher getCompressedMerchants];

    self.detailViewController = (MMDetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RestaurantCell";

    RestaurantCell *cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        //cell = [[RestaurantCell alloc]
        //    initWithStyle:UITableViewCellStyleDefault
        //   reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantTableCell" owner:self options:NULL] objectAtIndex:0];
    }


    cell.nameLabel.text = [[_restaurants objectAtIndex:indexPath.row] businessname];
    cell.numberLabel.text = [[_restaurants objectAtIndex:indexPath.row] phone];
    cell.ratinglabel.text = [[_restaurants objectAtIndex:indexPath.row] rating];
    UIImage *myImage = [UIImage imageWithData:
            [NSData dataWithContentsOfURL:
                    [NSURL URLWithString:[[_restaurants objectAtIndex:indexPath.row] picture]]]];
    cell.thumbnailImageView.image = myImage;

    cell.ratingview.progress = [[[_restaurants objectAtIndex:indexPath.row] rating] floatValue] / 10.0;
    [cell.ratingview setProgressViewStyle:UIProgressViewStyleBar];

    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
}

@end
