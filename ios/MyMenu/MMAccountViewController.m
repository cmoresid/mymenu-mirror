//
//  MMAccountViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import "MMAccountViewController.h"
#import "MMLoginManager.h"

#define kCurrentUser @"currentUser"

@interface MMAccountViewController ()

@end

@implementation MMAccountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updatePassword:(id)sender {
    
}

- (IBAction)updateDefaultLocation:(id)sender {
    
}

- (IBAction)logout:(id)sender {
    [[MMLoginManager sharedLoginManager] logoutUser];
    [self.splitViewController performSegueWithIdentifier:@"userMustLogin" sender:self];
}

@end
