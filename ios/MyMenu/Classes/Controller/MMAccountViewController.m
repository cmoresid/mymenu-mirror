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
#import "MMValidator.h"
#import "MMValidationManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMAccountViewController ()

- (void)updateUser:(NSNotification*)notification;
- (void)updateUserError:(NSNotification*)notification;
- (void)configureValidation;

@property(nonatomic, strong) MMValidationManager *passwordValidationManager;
@property(nonatomic, strong) MMValidationManager *locationValidationManager;

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

- (void)configureValidation {
    self.passwordValidationManager = [MMValidationManager new];
    
    MMRequiredTextFieldValidator *passwordRequiredValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.updatedPasswordField withValidationMessage:@"* New password must be provided."];
    
    MMMatchingTextFieldValidator *passwordMatchingValidator = [[MMMatchingTextFieldValidator alloc] initWithFirstTextField:self.updatedPasswordField withSecondTextField:self.confirmPasswordField withValidationMessage:@"* Passwords must match."];
    
    [self.passwordValidationManager addValidator:passwordRequiredValidator];
    [self.passwordValidationManager addValidator:passwordMatchingValidator];

    self.locationValidationManager = [MMValidationManager new];
    
    MMRequiredTextFieldValidator *locationValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.defaultLocationField withValidationMessage:@"* Location cannot be empty"];
    
    [self.locationValidationManager addValidator:locationValidator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MMUser *loggedInUser = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    self.givenNameField.text = loggedInUser.firstName;
    self.surnameField.text = loggedInUser.lastName;
    
    [self configureValidation];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
                                                      message:@"Update Successful."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)updateUserError:(NSNotification*)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
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
    NSArray *validationErrors  = [self.passwordValidationManager getValidationMessagesAsArray];
    
    if (validationErrors.count > 0) {
        NSString *validationMessage = [validationErrors componentsJoinedByString:@"\n"];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Validation Error(s)"
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }
    
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    userToUpdate.password = self.confirmPasswordField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MMLoginManager sharedLoginManager] beginUpdateUser:userToUpdate];
}

- (IBAction)updateDefaultLocation:(id)sender {
    NSArray *validationErrors  = [self.locationValidationManager getValidationMessagesAsArray];
    
    if (validationErrors.count > 0) {
        NSString *validationMessage = [validationErrors componentsJoinedByString:@"\n"];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Validation Error(s)"
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }
    
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    userToUpdate.city = self.defaultLocationField.text;

    [self.updatedPasswordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
    [self.tableView resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MMLoginManager sharedLoginManager] beginUpdateUser:userToUpdate];
}

- (IBAction)logout:(id)sender {
    [[MMLoginManager sharedLoginManager] logoutUser];
    [self.splitViewController performSegueWithIdentifier:@"userMustLogin" sender:self];
}

@end
