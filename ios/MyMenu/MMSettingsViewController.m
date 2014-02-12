//
//  MMSettingsViewController.m
//  MyMenu
//
//  Created by Chris Moulds on 2/4/2014.
//
//

#import "MMSettingsViewController.h"

#define kCurrentUser @"currentUser"

@interface MMSettingsViewController ()

@end

@implementation MMSettingsViewController

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

    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData *currentUser = [perfs objectForKey:kCurrentUser];

    if (currentUser != nil) {
        self.login.hidden = TRUE;
    }
    else {
        self.logout.hidden = TRUE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];

    NSData *user = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];

    NSLog(@"Logout");
}

- (IBAction)login:(id)sender {
    NSLog(@"Login");
}

@end
