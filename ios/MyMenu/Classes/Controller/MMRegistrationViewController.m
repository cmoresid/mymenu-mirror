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

#import "MMValidator.h"
#import "MMValidationManager.h"
#import "MMRegistrationViewController.h"
#import "MMDietaryRestrictionsViewController.h"
#import "MMUserNameValidator.h"
#import "MMTextField.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMRegistrationViewController ()

- (void)configureFormValidation;

@end

@implementation MMRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)configureFormValidation {
    MMRequiredTextFieldValidator *firstNameValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.firstNameField withValidationMessage:@"* First name is required."];

    MMRequiredTextFieldValidator *lastNameValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.lastNameField withValidationMessage:@"* Last name is required."];

    MMRegexTextFieldValidator *emailValidator = [[MMRegexTextFieldValidator alloc] initWithTextField:self.emailField withRegexString:@"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$" withValidationMessage:@"* Must be a valid email address."];

    MMRequiredTextFieldValidator *cityValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.cityField withValidationMessage:@"* City is required."];

    MMRequiredTextFieldValidator *provinceValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.provinceField withValidationMessage:@"* Province is required."];

    MMRequiredTextFieldValidator *genderValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.genderField withValidationMessage:@"* Gender is required."];

    MMRequiredTextFieldValidator *passwordValidator = [[MMRequiredTextFieldValidator alloc] initWithTextField:self.passwordField withValidationMessage:@"* Password must be provided."];

    MMMatchingTextFieldValidator *passwordMatchingValidator = [[MMMatchingTextFieldValidator alloc] initWithFirstTextField:self.passwordField withSecondTextField:self.confirmPasswordField withValidationMessage:@"* Passwords must match."];

    [self.validationManager addValidator:firstNameValidator];
    [self.validationManager addValidator:lastNameValidator];
    [self.validationManager addValidator:emailValidator];
    [self.validationManager addValidator:cityValidator];
    [self.validationManager addValidator:provinceValidator];
    [self.validationManager addValidator:genderValidator];
    [self.validationManager addValidator:passwordValidator];
    [self.validationManager addValidator:passwordMatchingValidator];

    // User name validation requires a difference approach since
    // the validation is asynchronous.
    self.userNameValidator = [[MMUserNameValidator alloc] initWithUserNameTextField:self.emailField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userNameValidate:)
                                                 name:kAvailableUserNameNotification object:nil];
}

- (void)userNameValidate:(NSNotification *)notificaton {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSNumber *result = notificaton.object;
    BOOL userExists = result.boolValue;

    if (userExists) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"User Name/Email is already in use."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    [self performSegueWithIdentifier:@"regToDietRest" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize shared user profile page
    self.userProfile = [[MMUser alloc] init];

    self.validationManager = [[MMValidationManager alloc] init];
    [self configureFormValidation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)createPopoverForTextField:(UITextField *)textField {
    return (textField == self.cityField ||
            textField == self.genderField ||
            textField == self.provinceField ||
            textField == self.birthdayField);
}

// If cancel button is clicked in navigation bar, dismiss
// the modal view.
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

// Configure text fields that require a popover view.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self createPopoverForTextField:textField]) {
        return YES;
    }
    
    MMRegistrationPopoverViewController *locationContent = [self getPopoverViewControllerForTextField:textField];
    locationContent.delegate = self;

    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:locationContent];

    popover.popoverContentSize = [self getPopoverViewSizeForTextField:textField];
    popover.delegate = self;

    self.locationPopoverController = popover;

    [self.locationPopoverController presentPopoverFromRect:textField.frame
                                                    inView:textField.superview
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];

    return FALSE;
}

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

- (void)didSelectCity:(NSString *)city {
    self.cityField.text = city;
    self.userProfile.city = city;

    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectGender:(NSString *)gender {
    self.genderField.text = gender;
    self.userProfile.gender = (gender != nil) ?
            [gender characterAtIndex:0] : 'U';

    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectProvince:(NSString *)province {
    self.provinceField.text = province;
    self.userProfile.locality = province;

    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectBirthday:(NSDate *)birthday {
    // Set birthday field
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    self.birthdayField.text = [dateFormatter stringFromDate:birthday];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:birthday];

    self.userProfile.birthday = [NSString stringWithFormat:@"%ld", (long) [components day]];
    self.userProfile.birthmonth = [NSString stringWithFormat:@"%ld", (long) [components month]];
    self.userProfile.birthyear = [NSString stringWithFormat:@"%ld", (long) [components year]];

    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    // Don't allow user to manually dismiss modal controller
    return FALSE;
}

// Instaniate the proper view controller depending on what text
// field is selected.
- (id)getPopoverViewControllerForTextField:(UITextField *)textField {
    // Lazily instaniate popover view controller for text field.
    [self hideKeyboard];
    if (textField == self.cityField) {
        if (self.cityPopoverViewController == nil) {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
            self.cityPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CityPopoverViewController"];
        }

        return self.cityPopoverViewController;
    }
    else if (textField == self.provinceField) {
        if (self.provincePopoverViewController == nil) {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
            self.provincePopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProvincePopoverViewController"];
        }

        return self.provincePopoverViewController;
    }
    else if (textField == self.genderField) {
        if (self.genderPopoverViewController == nil) {

            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
            self.genderPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GenderPopoverViewController"];
        }

        return self.genderPopoverViewController;
    }
    else if (textField == self.birthdayField) {
        if (self.birthdayPopoverViewController == nil) {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
            self.birthdayPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayPopoverViewController"];
        }

        return self.birthdayPopoverViewController;
    }

    return nil;
}

- (void)hideKeyboard {
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
    [self.genderField resignFirstResponder];
    [self.birthdayField resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self.provinceField resignFirstResponder];
}

/**
 *  Set the popover view size depending on which text field
 *  is selected.
 */
- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField {
    return (textField == self.birthdayField) ?
            CGSizeMake(400.0f, 220.0f) : CGSizeMake(350.0f, 200.0f);
}

- (IBAction)next:(id)sender {
    NSArray *validationMessages = [self.validationManager getValidationMessagesAsArray];

    if ([validationMessages count] > 0) {
        NSString *validationMessage = [validationMessages componentsJoinedByString:@"\n"];

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Validation Error(s)"
                                                          message:validationMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

        return;
    }

    // Check if user name exists on server, segue will
    // be performed in the userNameValidate: in this
    // controller.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.userNameValidator beginValidation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"regToDietRest"]) {
        self.userProfile.email = self.emailField.text;
        self.userProfile.password = self.passwordField.text;
        self.userProfile.firstName = self.firstNameField.text;
        self.userProfile.lastName = self.lastNameField.text;
        self.userProfile.country = @"CAN";
        MMDietaryRestrictionsViewController *destinationController = [segue destinationViewController];
        destinationController.userProfile = self.userProfile;
    }
}

@end
