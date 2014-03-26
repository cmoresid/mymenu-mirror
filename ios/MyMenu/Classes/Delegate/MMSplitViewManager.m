//
//  MMSplitViewDelegate.m
//  MyMenu
//
//  Created by Connor Moreside on 2014-03-25.
//
//

#import "MMSplitViewManager.h"

@interface MMSplitViewManager ()

@property(nonatomic, strong) UIBarButtonItem *navigationPaneButtonItem;
@property(nonatomic, strong) UIPopoverController *navigationPopoverController;

@end

@implementation MMSplitViewManager

// -------------------------------------------------------------------------------
//	setDetailViewController:
//  Custom implementation of the setter for the detailViewController property.
// -------------------------------------------------------------------------------
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
    if (self.navigationPopoverController)
        [self.navigationPopoverController dismissPopoverAnimated:YES];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {

    // If the barButtonItem does not have a title (or image) adding it to a toolbar
    // will do nothing.
    barButtonItem.title = @"View Profile Information";
    
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
