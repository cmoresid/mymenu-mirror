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

#import "MMMasterProfileViewController.h"

@interface MMMasterProfileViewController ()

@end

@implementation MMMasterProfileViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentDetailViewController = [self.splitViewController.viewControllers lastObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MMBaseNavigationController *masterNavigationController = [self.splitViewController.viewControllers firstObject];
    
    if (row == 0) {
        if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AccountNavigationController"]) {
            return;
        }
        
        self.accountController = (self.accountController != nil) ? self.accountController :
            [self.storyboard instantiateViewControllerWithIdentifier:@"AccountNavigationController"];
        
        self.currentDetailViewController = self.accountController;
    }
    else if (row == 1) {
        if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"ReviewsNavigationController"]) {
            return;
        }
        
        self.reviewsController = (self.reviewsController != nil) ? self.reviewsController :
        [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewsNavigationController"];
        
        self.currentDetailViewController = self.reviewsController;
    }
    else if (row == 2) {
        if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AboutNavigationController"]) {
            return;
        }
        
        self.aboutController = (self.accountController != nil) ? self.aboutController :
        [self.storyboard instantiateViewControllerWithIdentifier:@"AboutNavigationController"];
        
        self.currentDetailViewController = self.aboutController;
    }
    else if (row == 3) {
        if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"NotificationsNavigationController"]) {
            return;
        }
        
        self.notificationsController = (self.notificationsController != nil) ? self.notificationsController :
        [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsNavigationController"];
        
        self.currentDetailViewController = self.notificationsController;
    }
    
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, self.currentDetailViewController, nil];
}


@end
