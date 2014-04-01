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

#import "MMRestaurantSegue.h"
#import "MMSplitViewManager.h"
#import <RBStoryboardLink/RBStoryboardLink.h>

@implementation MMRestaurantSegue

- (void)perform {
    BOOL shouldAnimate = YES;
    
    UIViewController *source = self.sourceViewController;
    
    UISplitViewController *splitViewController = source.splitViewController;
    MMSplitViewManager *splitViewManager = (MMSplitViewManager *) splitViewController.delegate;
    
    UINavigationController *detailNavigationController = [splitViewController.viewControllers lastObject];
    RBStoryboardLink *destination = self.destinationViewController;
    
    // Trim the child controller stack to contain just the map view.
    NSInteger numberOfChildControllers = detailNavigationController.viewControllers.count;
    if (numberOfChildControllers >= 2) {
        detailNavigationController.viewControllers = @[detailNavigationController.viewControllers.firstObject];
        shouldAnimate = NO;
    }
    
    // Dismiss the sliding drawer if in portrait mode
    [splitViewManager dismissSlideOverDrawer];
    [detailNavigationController pushViewController:destination animated:shouldAnimate];
}

@end
