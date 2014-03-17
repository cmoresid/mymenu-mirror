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

@interface MMSplitViewController ()

@end

@implementation MMSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (BOOL)needsTopLayoutGuide {
    return FALSE;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title color of all nested navigation bars
    // to white.
    UINavigationController *navController;
    for (id controller in self.viewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController *) controller;
            navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        }
    }

    UINavigationController *masterNavController = [self.viewControllers firstObject];
    UINavigationController *detailNavController = [self.viewControllers lastObject];
    
    MMMasterRestaurantTableViewController *master = (MMMasterRestaurantTableViewController *)masterNavController.topViewController;
    MMDetailMapViewController *detail = (MMDetailMapViewController *) detailNavController.topViewController;
    
    master.delegate = detail;
    self.delegate = detail;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
