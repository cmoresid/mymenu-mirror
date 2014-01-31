//
//  MMSpecialsViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/30/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMSpecialsViewController.h"
#import "MMSpecialsCollectionViewController.h"

@interface MMSpecialsViewController ()

@end

@implementation MMSpecialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup Next View for Type
// TODO: Use right numbers for the type in database
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Dessert"]) {
        [(MMSpecialsCollectionViewController *) [segue destinationViewController] setSpecialsType:0];
    } else if ([[segue identifier] isEqualToString:@"Food"]) {
        [(MMSpecialsCollectionViewController *) [segue destinationViewController] setSpecialsType:1];
    } else if ([[segue identifier] isEqualToString:@"Drinks"]) {
        [(MMSpecialsCollectionViewController *) [segue destinationViewController] setSpecialsType:2];
    }
}

@end
