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
#import "MMAboutViewController.h"
#import "MMAccountViewController.h"
#import "MMSplitViewManager.h"

typedef NS_ENUM(NSInteger, MMProfilePageType) {
    MMAccountPage = 0,
    MMAboutPage = 1
};

@interface MMMasterProfileViewController ()

@end

@implementation MMMasterProfileViewController

#pragma mark - View Controller Methods

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.currentDetailViewController = ((UINavigationController *) [self.splitViewController.viewControllers lastObject]).topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    
    MMSplitViewManager *detailViewManager = (MMSplitViewManager *) self.splitViewController.delegate;

    switch (selectedRow) {
        case MMAccountPage:
            [self configureAccountController];
            break;
        case MMAboutPage:
            [self configureAboutController];
            break;
        default:
            break;
    }
    
    detailViewManager.detailViewController = (UIViewController<MMDetailViewController> *) self.currentDetailViewController;
}

#pragma mark - Configure Child View Controllers Methods

- (void)configureAccountController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AccountViewController"]) {
        return;
    }

    self.accountController = (self.accountController != nil) ? self.accountController :
            [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];

    self.currentDetailViewController = self.accountController;
}

- (void)configureAboutController {
    if ([self.currentDetailViewController.restorationIdentifier isEqualToString:@"AboutViewController"]) {
        return;
    }

    self.aboutController = (self.accountController != nil) ? self.aboutController :
            [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];

    self.currentDetailViewController = self.aboutController;
}

@end
