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

#import "MMMasterRestaurantTableViewController.h"
#import "MMLocationManager.h"
#import "RestaurantCell.h"
#import "MMDetailMapViewController.h"
#import "MMRestaurantViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+MyMenuColors.h"
#import "MMUser.h"
#import "NSArray+MerchantSort.h"
#import "MMRestaurantViewController.h"
#import <RBStoryboardLink/RBStoryboardLink.h>

@interface MMMasterRestaurantTableViewController () {
    NSMutableArray *_objects;
}

- (void)updatedOrderByFilter:(UISegmentedControl*)control;

@end

@implementation MMMasterRestaurantTableViewController

- (void)awakeFromNib {
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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

    if (_searchflag == TRUE){
        _filteredrestaurants = compressedMerchants;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateList object:_filteredrestaurants];
        _searchflag = FALSE;
            [((UITableView *) self.searchDisplayController.searchResultsTableView) reloadData];
    }
    else{
    _restaurants = compressedMerchants;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateList
                                                           object:_restaurants];
    }
    
    [self.tableView reloadData];
}

- (void)didRetrieveMerchant:(MMMerchant *)merchant withResponse:(MMDBFetcherResponse *)response {
    self.selectedRestaurant = merchant;
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUserLocation:)
                                                 name:kRetrievedUserLocation
                                               object:nil];
    
    _searchflag = false;

    self.detailViewController = (MMDetailMapViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.orderbySegmentControl addTarget:self
                                   action:@selector(updatedOrderByFilter:)
                         forControlEvents:UIControlEventValueChanged];
}

- (void)updatedOrderByFilter:(UISegmentedControl*)control {
    switch ([control selectedSegmentIndex]) {
        case 0:
            _restaurants = [_restaurants sortMerchantByDistance];
            break;
        case 1:
            _restaurants = [_restaurants sortMerchantByTopRated];
            break;
        case 2:
            _restaurants = [_restaurants sortMerchantByCusine];
            break;
        default:
            break;
    }

    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveUserLocation:(NSNotification *)notification {
    _location = notification.object;
    self.dbFetcher = [[MMDBFetcher alloc] init];
    self.dbFetcher.delegate = self;
    [self.dbFetcher getCompressedMerchants:_location];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredrestaurants count];
    } else {
        
        return [_restaurants count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RestaurantCell";

    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantTableCell" owner:self options:NULL] objectAtIndex:0];
    }

    
    MMMerchant *restaurant;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        restaurant = [_filteredrestaurants objectAtIndex:indexPath.row];
    } else {
        restaurant = [_restaurants objectAtIndex:indexPath.row];
    }
    

    cell.ratingBg.backgroundColor = [UIColor lightBackgroundGray];
    cell.ratingBg.layer.cornerRadius = 5;
    cell.nameLabel.text = restaurant.businessname;
    cell.categoryLabel.text = restaurant.category;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];

    NSString *rate = [formatter stringFromNumber:[[_restaurants objectAtIndex:indexPath.row] rating]];
    if ([rate isEqualToString:@".0"]) {
        rate = @"N/A";
    }

    if ([restaurant.distfromuser compare:[NSNumber numberWithFloat:0.0f]] == NSOrderedAscending) {
        NSNumberFormatter *oneDecFormat = [[NSNumberFormatter alloc] init];
        [oneDecFormat setRoundingMode:NSNumberFormatterRoundHalfUp];
        [oneDecFormat setMaximumFractionDigits:0];

        NSString *stringFormat = @"%@ m";
        NSNumber *dist = [NSNumber numberWithDouble:restaurant.distfromuser.doubleValue * 1000.0];
        NSString *formattedValue = [oneDecFormat stringFromNumber:dist];

        cell.distanceLabel.text = [NSString stringWithFormat:stringFormat, formattedValue];
    } else {
        NSNumberFormatter *oneDecFormat = [[NSNumberFormatter alloc] init];
        [oneDecFormat setRoundingMode:NSNumberFormatterRoundHalfUp];
        [oneDecFormat setMaximumFractionDigits:1];

        NSString *stringFormat = @"%@ km";
        NSString *formattedValue = [oneDecFormat stringFromNumber:restaurant.distfromuser];

        cell.distanceLabel.text = [NSString stringWithFormat:stringFormat, formattedValue];
    }

    cell.ratinglabel.text = rate;
    cell.addressLabel.text = restaurant.address;

    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[restaurant picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self.dbFetcher getMerchant:[[_filteredrestaurants objectAtIndex:indexPath.row] mid]];
    } else {
        [self.dbFetcher getMerchant:[[_restaurants objectAtIndex:indexPath.row] mid]];
    }
    [self.dbFetcher getMerchant:[[self.restaurants objectAtIndex:indexPath.row] mid]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"restaurantSegue"]) {
        UINavigationController *controller = segue.destinationViewController;
        
        RBStoryboardLink *storyboardLink = [controller.viewControllers firstObject];
        MMRestaurantViewController *restaurantViewController = (MMRestaurantViewController*)storyboardLink.scene;
        
        restaurantViewController.currentMerchant = _selectedRestaurant;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    _searchflag = TRUE;
    if ([searchBar.text length] != 0){
        self.dbFetcher = [[MMDBFetcher alloc] init];
        self.dbFetcher.delegate = self;
        [self.dbFetcher getCompressedMerchantsByName:_location withName:searchBar.text];
    }
    
}

/* When the user clicks 'cancel' */
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateList
                                                        object:_restaurants];

}

@end
