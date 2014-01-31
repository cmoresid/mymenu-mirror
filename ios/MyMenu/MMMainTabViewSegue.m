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

#import "MMMainTabViewSegue.h"

@implementation MMMainTabViewSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;

    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];

    // Store original centre point of the destination view
    CGRect originalFrame = destinationViewController.view.frame;

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow my precious!!
                         destinationViewController.view.frame = CGRectMake(0, originalFrame.size.height, originalFrame.size.width, originalFrame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [destinationViewController.view removeFromSuperview]; // remove that bitch!

                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL];
                     }];
}

@end
