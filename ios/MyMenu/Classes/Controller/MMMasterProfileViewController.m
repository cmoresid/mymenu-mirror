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

typedef NS_ENUM(NSInteger, MMProfilePageType) {
    MMAccountPage = 0,
    MMReviewsPage = 1,
    MMAboutPage = 2,
    MMNotificationPage = 3
};

@interface MMMasterProfileViewController ()

@end

@implementation MMMasterProfileViewController

#pragma mark - View Controller Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    MMBaseNavigationController *masterNavigationController = [self.splitViewController.viewControllers firstObject];
    
    switch (selectedRow) {
        case MMAccountPage:
            [self configureAccountController];
            break;
        case MMReviewsPage:
            [self configureReviewsController];
            break;
        case MMAboutPage:
            [self configureAboutController];
            break;
        case MMNotificationPage:
            [self configureNotificationsController];
            break;
        default:
            break;
    }
    
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, self.currentDetailViewController, nil];
}

#pragma mark - Configure Child View Controllers Methods

- (void)configureAccountController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AccountNavigationController"]) {
        return;
    }
    
    self.accountController = (self.accountController != nil) ? self.accountController :
    [self.storyboard instantiateViewControllerWithIdentifier:@"AccountNavigationController"];
    
    self.currentDetailViewController = self.accountController;
}

- (void)configureReviewsController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"ReviewsNavigationController"]) {
        return;
    }
    
    self.reviewsController = (self.reviewsController != nil) ? self.reviewsController :
    [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewsNavigationController"];
    
    self.currentDetailViewController = self.reviewsController;
}

- (void)configureAboutController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AboutNavigationController"]) {
        return;
    }
    
    self.aboutController = (self.accountController != nil) ? self.aboutController :
    [self.storyboard instantiateViewControllerWithIdentifier:@"AboutNavigationController"];
    
    self.currentDetailViewController = self.aboutController;
}

- (void)configureNotificationsController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"NotificationsNavigationController"]) {
        return;
    }
    
    self.notificationsController = (self.notificationsController != nil) ? self.notificationsController :
    [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsNavigationController"];
    
    self.currentDetailViewController = self.notificationsController;
}

@end
