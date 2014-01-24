//
//  MMSplitViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMSplitViewController.h"

@interface MMSplitViewController ()

@end

@implementation MMSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Get the Nav Controller for the Slider
	UINavigationController *navigationController = [self.viewControllers lastObject];
	self.delegate = (id)navigationController.topViewController;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
