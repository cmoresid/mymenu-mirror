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

#import "MMMasterViewController.h"
#import "MMMapDelegate.h"
#import "RestaurantCell.h"
#import "MMDetailViewController.h"
#import "MMDBFetcher.h"
#import "MMRestaurantViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+MyMenuColors.h"
#import "NSArray+MerchantSort.h"

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

- (void)didRetrieveCompressedMerchants:(NSArray *)compressedMerchants withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }
    
    // Successful retrieved restaurant list.
    
    self.restaurants = [compressedMerchants sortMerchant];
    
    [((UITableView*)self.view) reloadData];
}

- (void)didRetrieveMerchant:(MMMerchant *)merchant withResponse:(MMDBFetcherResponse *)response {
    
    self.selectRest = merchant;
    
    NSLog(@"the id is : %@", self.selectRest.mid);
    NSLog(@"Restaurant desc = %@", self.selectRest.desc);
    
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUserLocation:)
                                                 name:kRetrievedUserLocation
                                               object:nil];

    self.detailViewController = (MMDetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveUserLocation:(NSNotification*)notification {
    MKUserLocation *location = notification.object;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"Lat: %@", [NSNumber numberWithDouble:coordinate.latitude]);
    NSLog(@"Longa: %@", [NSNumber numberWithDouble:coordinate.longitude]);
    
    NSLog(@"Did recieve user location.");
    self.dbFetcher = [[MMDBFetcher alloc] init];
    self.dbFetcher.delegate = self;
    [self.dbFetcher getCompressedMerchants:location];
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
// Theres only one section in this view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Return the amount of restaurants.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RestaurantCell";

    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantTableCell" owner:self options:NULL] objectAtIndex:0];
    }
	cell.ratingBg.backgroundColor = [UIColor lightBackgroundGray];
	cell.ratingBg.layer.cornerRadius = 5;
    cell.nameLabel.text = [[_restaurants objectAtIndex:indexPath.row] businessname];
    cell.numberLabel.text = [[_restaurants objectAtIndex:indexPath.row] phone];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
    cell.ratinglabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[[_restaurants objectAtIndex:indexPath.row] rating] ]];
    
    MMMerchant __weak *merchant = [_restaurants objectAtIndex:indexPath.row];
    
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[merchant picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

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
// Cell size is 80 so its hard coded in.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"Selected %@", indexPath);
    NSLog(@"ABC");
    NSLog(@"the ID is %@" , [[self.restaurants objectAtIndex:indexPath.row] mid]);
    //_selectRest = [self.restaurants objectAtIndex:indexPath.row];
    
    [self.dbFetcher getMerchant:[[self.restaurants objectAtIndex:indexPath.row] mid]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"restaurantSegue"]){
        MMRestaurantViewController *RestaurantController = [segue destinationViewController];
        NSLog(@"PREPARING FOR SEGUE NOOW");
        RestaurantController.selectedRestaurant = _selectRest;
        NSLog(@"PREPARING FOR SEGUE NOOW2222");

        
    }
}

@end
