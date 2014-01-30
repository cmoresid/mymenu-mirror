//
//  MMMainTabViewSegue.m
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
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
