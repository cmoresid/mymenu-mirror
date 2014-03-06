//
//  MMSettingsSplitViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 3/5/2014.
//
//

#import "MMProfileSplitViewController.h"
#import "MMLoginManager.h"

@interface MMProfileSplitViewController ()

@end

@implementation MMProfileSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
        [[MMLoginManager sharedLoginManager] logoutUser];
        [self performSegueWithIdentifier:@"userMustLogin" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINavigationController *navController;
    for (id controller in self.viewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*) controller;
            navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
