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

#import "MMSplitViewManager.h"

@interface MMSplitViewManager ()

@property(nonatomic, strong) UIBarButtonItem *navigationPaneButtonItem;
@property(nonatomic, strong) UIPopoverController *navigationPopoverController;
@property(nonatomic, strong) NSString *navigationButtonItemText;

@end

@implementation MMSplitViewManager

- (instancetype)initWithNavigationButtonItemText:(NSString *)buttonText {
    self = [super init];
    
    if (self) {
        self.navigationButtonItemText = buttonText;
    }
    
    return self;
}

- (void)setDetailViewController:(UIViewController<MMDetailViewController> *)detailViewController {
    // Clear any bar button item from the detail view controller that is about to
    // no longer be displayed.
    self.detailViewController.navigationPaneBarButtonItem = nil;
    
    _detailViewController = detailViewController;
    
    // Set the new detailViewController's navigationPaneBarButtonItem to the value of our
    // navigationPaneButtonItem.  If navigationPaneButtonItem is not nil, then the button
    // will be displayed.
    _detailViewController.navigationPaneBarButtonItem = self.navigationPaneButtonItem;
    
    // Update the split view controller's view controllers array.
    // This causes the new detail view controller to be displayed.
    UINavigationController *masterNavigationController = [self.splitViewController.viewControllers firstObject];
    
    UINavigationController *detailNavigationController = [self.splitViewController.viewControllers lastObject];
    detailNavigationController.viewControllers = @[_detailViewController];
    
    self.splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
    
    // Dismiss the navigation popover if one was present.  This will
    // only occur if the device is in portrait.
    [self dismissSlideOverDrawer];
}

- (void)dismissSlideOverDrawer {
    if (self.navigationPopoverController) {
        [self.navigationPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {

    // If the barButtonItem does not have a title (or image) adding it to a toolbar
    // will do nothing.
    barButtonItem.title = self.navigationButtonItemText;
    
    self.navigationPaneButtonItem = barButtonItem;
    self.navigationPopoverController = pc;
    
    // Tell the detail view controller to show the navigation button.
    self.detailViewController.navigationPaneBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    self.navigationPaneButtonItem = nil;
    self.navigationPopoverController = nil;
    
    // Tell the detail view controller to remove the navigation button.
    self.detailViewController.navigationPaneBarButtonItem = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    
    return UIInterfaceOrientationIsPortrait(orientation);
}

@end
