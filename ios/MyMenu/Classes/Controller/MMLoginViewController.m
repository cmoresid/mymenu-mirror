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

#import <MBProgressHUD/MBProgressHUD.h>
#import "MMLoginViewController.h"
#import "MMLoginManager.h"
#import "MMValidator.h"
#import "MMValidationManager.h"

@interface MMLoginViewController ()

@property(nonatomic, strong) MMValidationManager *validationManager;

- (void)configureValidation;
- (void)canUserLogin:(NSNotification*)notification;
- (void)userLoginError:(NSNotification*)notification;

@end

@implementation MMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailAddress.delegate = self;
    self.password.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(canUserLogin:)
                                                 name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginError:)
                                                 name:kUserLoginErrorNotification object:nil];
    
    [self registerForKeyboardNotifications];
    [self configureValidation];
}

- (void)configureValidation {
    self.validationManager = [MMValidationManager new];
    
    MMRequiredTextFieldValidator *userNameValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.emailAddress
                                                                                        withValidationMessage:@"* User name must be provided."];
    MMRequiredTextFieldValidator *passwordValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.password withValidationMessage:@"* Password must be provided."];
    
    [self.validationManager addValidator:userNameValidator];
    [self.validationManager addValidator:passwordValidator];
}

- (void)canUserLogin:(NSNotification*)notification {
    MMUser *userToLogin = notification.object;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (!userToLogin) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username or Password!"
                                                          message:@"Please enter a valid user name and password."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }
    
    [self performSegueWithIdentifier:@"loginAndMainScreen" sender:self];
}

- (void)userLoginError:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                      message:@"Unable to communicate with server."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    kbSize.height = kbSize.height / 1.7f;
    kbSize.width = kbSize.width / 1.7f;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (IBAction)login:(id)sender {
    NSArray *validationMessages = [self.validationManager getValidationMessagesAsArray];
    
    if ([validationMessages count] > 0) {
        NSString *validationMessage = [validationMessages componentsJoinedByString:@"\n"];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable To Login"
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }

    // If keyboard is shown, hide it when trying
    // to login.
    [self.password resignFirstResponder];
    [self.emailAddress resignFirstResponder];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MMLoginManager sharedLoginManager] beginLoginWithUserName:self.emailAddress.text
                                                   withPassword:self.password.text];
}

- (IBAction)loginAsGuest:(id)sender {
    [[MMLoginManager sharedLoginManager] loginAsGuest];
    
    [self performSegueWithIdentifier:@"loginAndMainScreen" sender:self];
}

@end