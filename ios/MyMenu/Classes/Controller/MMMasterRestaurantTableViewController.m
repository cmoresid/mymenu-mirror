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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "MMMerchantService.h"
#import "UISearchBar+RAC.h"
#import "MMSplitViewController.h"
#import "MMPresentationFormatter.h"
#import "MMMapPopOverViewController.h"

@interface MMMasterRestaurantTableViewController ()

@property(nonatomic, strong) NSNumber *selectedMerchantId;

- (void)updatedOrderByFilter:(UISegmentedControl *)control;

@end

@implementation MMMasterRestaurantTableViewController

- (void)awakeFromNib {
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Throttle connection, just to make sure if multiple location signals
    // are sent at the same time, you ignore the first ones. Sometimes, duplicate
    // pins will get dropped if you don't throttle.
    @weakify(self);
    [[[[[MMLocationManager sharedLocationManager].getLatestLocation
        throttle:3.0]
        flattenMap:^RACStream *(CLLocation *location) {
            return [[MMMerchantService sharedService] getDefaultCompressedMerchantsForLocation:location];
        }]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSMutableArray *compressedMerchants) {
            @strongify(self);
            _restaurants = compressedMerchants;
            [self.delegate didReceiveMerchants:compressedMerchants];
            
            [self.tableView reloadData];
    }];
    
    RAC(self, filteredrestaurants) = [[[[[[[[self.merchantSearchBar rac_textSignal]
        skip:1]       // Skip the initial binding signal
        throttle:0.6] // Only try to search every 0.6 seconds
        doNext:^(NSString *searchValue) {
            // Perform side-effects here
            if ([searchValue isEqualToString:@""])
                [self.delegate didReceiveMerchants:[NSMutableArray new]];
        }]
        filter:^BOOL(NSString *searchValue) {
            // Only perform search if non-empty string
            return ![searchValue isEqualToString:@""];
        }]
        flattenMap:^RACStream *(NSString *searchValue) {
            // Retrieve a list of merchants with name of specified search value
            return [[MMMerchantService sharedService] getCompressedMerchantsForLocation:self.location withName:searchValue];
        }]
        doNext:^(NSMutableArray *searchResults) {
            [self.delegate didReceiveMerchants:searchResults];
        }]
        map:^NSArray*(NSMutableArray *searchResults) {
            // Bind search results to filteredrestaurants variable now
            return [searchResults copy];
        }];
    
    [RACObserve(self, filteredrestaurants) subscribeNext:^(id x) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    
    [[self.orderbySegmentControl rac_newSelectedSegmentIndexChannelWithNilValue:0]
        subscribeNext:^(id x) {
            @strongify(self);
            [self updatedOrderByFilter:self.orderbySegmentControl];
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)updatedOrderByFilter:(UISegmentedControl *)control {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    else {
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
    cell.restaurantNameLabel.text = restaurant.businessname;
    cell.categoryLabel.text = restaurant.category;
    cell.ratinglabel.text = [MMPresentationFormatter formatRatingForRawRating:restaurant.rating];
    cell.distanceLabel.text = [MMPresentationFormatter formatDistance:restaurant.distfromuser];
    cell.addressLabel.text = restaurant.address;

    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:[restaurant picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Cell size is 80 so its hard coded in.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMerchantId = self.searchflag ? ((MMMerchant *)[self.filteredrestaurants objectAtIndex:indexPath.row]).mid : ((MMMerchant *)[self.restaurants objectAtIndex:indexPath.row]).mid;
    
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"restaurantSegue"]) {
        RBStoryboardLink *storyBoardLink = (RBStoryboardLink *) segue.destinationViewController;
        MMRestaurantViewController *restaurantViewController = (MMRestaurantViewController *) storyBoardLink.scene;
        
        restaurantViewController.currentMerchantId = ([sender isKindOfClass:MMMapPopOverViewController.class]) ? ((MMMapPopOverViewController *)sender).merchant.mid : self.selectedMerchantId;
    }
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    self.filteredrestaurants = @[];
    [self.delegate didReceiveMerchants:[NSMutableArray new]];
    
    self.searchflag = YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.delegate didReceiveMerchants:[self.restaurants mutableCopy]];
    
    self.filteredrestaurants = @[];
    self.searchflag = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isEqualToString:@""] && self.searchflag) {
        self.filteredrestaurants = @[];
        return YES;
    }
    
    return NO;
}

@end
