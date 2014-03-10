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

#import "MMMainTabBarViewController.h"
#import "UIColor+MyMenuColors.h"

@interface MMMainTabBarViewController ()

@end

@implementation MMMainTabBarViewController

#pragma mark - View Controller Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTabBarAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure Tab Bar Appearance Methods

- (void)configureTabBarAppearance {
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor darkTealColor]];


    UIColor *color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : color} forState:UIControlStateNormal];
}

#pragma mark - MMDBFetcher Delegate Methods

- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    NSLog(@"Did create user.");
}

- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    NSLog(@"Did add user restrictions.");
}

@end
