//
//  MMAccountViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import "MMAccountViewController.h"
#import "MMLoginManager.h"
#import "MMUser.h"

@interface MMAccountViewController ()

- (void)updateUser:(NSNotification*)notification;
- (void)updateUserError:(NSNotification*)notification;

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

    MMUser *loggedInUser = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    self.givenNameField.text = loggedInUser.firstName;
    self.surnameField.text = loggedInUser.lastName;
    self.birthdayField.text = [NSString stringWithFormat:@"%@/%@/%@",
                               loggedInUser.birthmonth,
                               loggedInUser.birthday,
                               loggedInUser.birthyear];
    // TODO: Map to proper values
    self.genderField.text = @"Male";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser:)
                                                 name:kUserUpdatedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserError:)
                                                 name:kUserUpdateErrorNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUser:(NSNotification*)notification {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
                                                      message:@"Update Successful."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)updateUserError:(NSNotification*)notification {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Unable to update information."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updatePassword:(id)sender {
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    userToUpdate.password = self.confirmPasswordField.text;
    
    [[MMLoginManager sharedLoginManager] beginUpdateUser:userToUpdate];
}

- (IBAction)updateDefaultLocation:(id)sender {
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    userToUpdate.city = self.defaultLocationField.text;
    
    [[MMLoginManager sharedLoginManager] beginUpdateUser:userToUpdate];
}

- (IBAction)logout:(id)sender {
    [[MMLoginManager sharedLoginManager] logoutUser];
    [self.splitViewController performSegueWithIdentifier:@"userMustLogin" sender:self];
}

@end
