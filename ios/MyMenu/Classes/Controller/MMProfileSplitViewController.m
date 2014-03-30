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

#import "MMProfileSplitViewController.h"
#import "MMAccountViewController.h"
#import "MMSplitViewManager.h"
#import "MMLoginManager.h"
#import <objc/message.h>

@interface MMProfileSplitViewController ()

@property(nonatomic, strong) MMSplitViewManager *manager;

@end

@implementation MMProfileSplitViewController

#pragma mark - View Controller Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
        [[MMLoginManager sharedLoginManager] logoutUser];
        [self performSegueWithIdentifier:@"userMustLogin" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[MMSplitViewManager alloc] initWithNavigationButtonItemText:NSLocalizedString(@"View Profile Information", nil)];
    
    self.manager.splitViewController = self;
    self.delegate = self.manager;
    
    UINavigationController *navController = [self.viewControllers lastObject];
    MMAccountViewController *startingController = (MMAccountViewController *) navController.topViewController;
    
    self.presentsWithGesture = NO;
    
    self.manager.detailViewController = startingController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RBStoryboardSourceLink Delegate Methods

- (BOOL)needsTopLayoutGuide {
    return NO;
}

#pragma mark - Rotation Events

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:orientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io
                                         duration:(NSTimeInterval)duration {
    
    [super willAnimateRotationToInterfaceOrientation:io duration:duration];
}

- (void)didRotateFromInterfaceOrientation: (UIInterfaceOrientation)orientation {
    [super didRotateFromInterfaceOrientation: orientation];
    
    // Not sure why but this delegate method does not get called on its own when
    // the rotation events are forwarded. It must have something to do with the
    // view not actually being visible.
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        id delegate = [self delegate];
        [delegate splitViewController:self
               willShowViewController:[[self viewControllers] objectAtIndex:0]
            invalidatingBarButtonItem:[super valueForKey:@"_barButtonItem"]];
    }
}

@end
