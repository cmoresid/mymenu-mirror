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
#import "MMStaticDataHelper.h"

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
    [[UITabBar appearance] setBarTintColor:[UIColor sidebarBackgroundGray]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor tealColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];

    NSArray *selectedImages = [[MMStaticDataHelper sharedDataHelper] getSelectedTabBarImageNames];
    NSArray *tabBarItems = self.tabBar.items;
    
    for (int i = 0; i < tabBarItems.count; i++) {
        UITabBarItem *tabBarItem = tabBarItems[i];
        
        UIImage *image = tabBarItem.image;
        tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

#pragma mark - Rotation Events

- (BOOL)shouldAutomaticallyForwardRotationMethods {
    return YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:orientation duration:duration];
    
    // Forward manually to any non-viewable child split view controllers.
    for (UIViewController *cvc in self.childViewControllers) {
        if ((cvc.view.superview == nil) && ([cvc isKindOfClass: [UISplitViewController class]])) {
            [cvc willRotateToInterfaceOrientation:orientation duration:duration];
        }
    }
}

- (void)didRotateFromInterfaceOrientation: (UIInterfaceOrientation)orientation {
    [super didRotateFromInterfaceOrientation:orientation];
    
    for (UIViewController *cvc in self.childViewControllers) {
        if ((cvc.view.superview == nil) && ([cvc isKindOfClass:[UISplitViewController class]])) {
            [cvc didRotateFromInterfaceOrientation:orientation];
        }
    }
}

@end
