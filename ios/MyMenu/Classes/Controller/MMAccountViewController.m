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
#import "MMSplitViewManager.h"
#import "MMTextField.h"
#import <RACEXTScope.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMAccountViewController ()

- (void)registerForUpdateUserNotifications;
- (void)unregisterForUpdateUserNotifications;
- (void)updateUser:(NSNotification *)notification;
- (void)updateUserError:(NSNotification *)notification;
- (void)configureValidation;

@property(nonatomic, strong) MMValidationManager *passwordValidationManager;
@property(nonatomic, strong) MMValidationManager *locationValidationManager;

@end

@implementation MMAccountViewController

#pragma mark - Custom Accessor Methods

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem {
    if (navigationPaneBarButtonItem == _navigationPaneBarButtonItem)
        return;
    
    if (navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
    else
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
}

#pragma mark - View Controller Methods

- (void)configureNavigationItems {
    self.navigationItem.title = NSLocalizedString(@"Account Information", nil);
    
    if (self.navigationPaneBarButtonItem) {
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem
                                         animated:NO];
    }
}

- (void)populateFieldsFromLoggedInUser {
    MMUser *loggedInUser = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    self.emailAddressField.text = loggedInUser.email;
    self.givenNameField.text = loggedInUser.firstName;
    self.surnameField.text = loggedInUser.lastName;
    
    self.emailAddressField.enabled = NO;
    self.givenNameField.enabled = NO;
    self.surnameField.enabled = NO;
    
    self.defaultCity.placeholder = loggedInUser.city;
    self.defaultLocality.placeholder = loggedInUser.locality;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.updatedPasswordField.delegate = self;
    self.confirmPasswordField.delegate = self;
    
    [self configureNavigationItems];
    [self populateFieldsFromLoggedInUser];
    [self configureValidation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForUpdateUserNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self unregisterForUpdateUserNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *) textField {
    BOOL didResign = [textField resignFirstResponder];
    
    if (!didResign)
        return NO;
    
    if ([textField isKindOfClass:[MMTextField class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[(MMTextField *)textField nextField] becomeFirstResponder];
        });
    }
    
    return YES;
}

#pragma mark - Validation

- (void)configureValidation {
    self.passwordValidationManager = [MMValidationManager new];

    MMRequiredTextFieldValidator *passwordRequiredValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.updatedPasswordField withValidationMessage:NSLocalizedString(@"* New password must be provided.", nil)];

    MMMatchingTextFieldValidator *passwordMatchingValidator = [[MMMatchingTextFieldValidator alloc] initWithFirstTextField:self.updatedPasswordField withSecondTextField:self.confirmPasswordField withValidationMessage:NSLocalizedString(@"* Passwords must match.", nil)];

    [self.passwordValidationManager addValidator:passwordRequiredValidator];
    [self.passwordValidationManager addValidator:passwordMatchingValidator];

    self.locationValidationManager = [MMValidationManager new];

    MMRequiredTextFieldValidator *locationValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.defaultCity withValidationMessage:NSLocalizedString(@"* Location cannot be empty.", nil)];

    [self.locationValidationManager addValidator:locationValidator];
}

#pragma mark - Register Notification Methods

- (void)registerForUpdateUserNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser:)
                                                 name:kUserUpdatedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserError:)
                                                 name:kUserUpdateErrorNotification
                                               object:nil];
}

- (void)unregisterForUpdateUserNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserUpdatedNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserUpdateErrorNotification
                                                  object:nil];
}

#pragma mark - Update User Notification Callback Methods

- (void)updateUser:(NSNotification *)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                      message:NSLocalizedString(@"Update Successful.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [message show];
}

- (void)updateUserError:(NSNotification *)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                      message:NSLocalizedString(@"Unable to update information.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - Action Methods

- (IBAction)updatePassword:(id)sender {
    NSArray *validationErrors = [self.passwordValidationManager getValidationMessagesAsArray];

    if (validationErrors.count > 0) {
        NSString *validationMessage = [validationErrors componentsJoinedByString:@"\n"];

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error(s)", nil)
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
    NSArray *validationErrors = [self.locationValidationManager getValidationMessagesAsArray];

    if (validationErrors.count > 0) {
        NSString *validationMessage = [validationErrors componentsJoinedByString:@"\n"];

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error(s)", nil)
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];

        [message show];
        return;
    }

    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    userToUpdate.city = self.defaultCity.text;

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
