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

#import "MMSplitViewController.h"
#import "MMLocationManager.h"
#import "MMMasterRestaurantTableViewController.h"
#import "MMDetailMapViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MMSplitViewManager.h"

@interface MMSplitViewController ()

@property(nonatomic, strong) MMSplitViewManager *manager;

@end

@implementation MMSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureChildNavigationBarAppearance];

    self.manager = [[MMSplitViewManager alloc] initWithNavigationButtonItemText:NSLocalizedString(@"View Restaurants", nil)];
    self.manager.splitViewController = self;
    self.delegate = self.manager;
    
    UINavigationController *masterNavController = [self.viewControllers firstObject];
    UINavigationController *detailNavController = [self.viewControllers lastObject];
    
    MMMasterRestaurantTableViewController *master = (MMMasterRestaurantTableViewController *)masterNavController.topViewController;
    MMDetailMapViewController *detail = (MMDetailMapViewController *) detailNavController.topViewController;
    
    self.manager.detailViewController = detail;
    master.delegate = detail;
    
    self.presentsWithGesture = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (void)configureChildNavigationBarAppearance {
    UINavigationController *navController;
    
    for (id controller in self.viewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController *) controller;
            navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        }
    }
}

@end
