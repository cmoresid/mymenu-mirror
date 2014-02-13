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

#import "MMRegistrationViewController.h"
#import "MMDietaryRestrictionsViewController.h"

@interface MMRegistrationViewController ()

@end

@implementation MMRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Allow view controller to act as
    // delegate for the following text fields.
    self.cityField.delegate = self;
    self.genderField.delegate = self;
    self.provinceField.delegate = self;
    self.birthdayField.delegate = self;

    // Initialize shared user profile page
    self.userProfile = [[MMUser alloc] init];

    // Register for keyboard notifications to allow
    // for view to scroll to text field
    [self registerForKeyboardNotifications];
    [self.emailField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// If cancel button is clicked in navigation bar, dismiss
// the modal view.
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

// Configure text fields that require a popover view.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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

// Set the popover view size depending on which text field
// is selected.
- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField {
    return (textField == self.birthdayField) ?
            CGSizeMake(450.0f, 220.0f) : CGSizeMake(350.0f, 200.0f);
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

// If a text field is not visible, move the content view
// using an animation to bring the text field into view by
// scrolling the content view.
- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    kbSize.height = kbSize.height / 1.8f;
    kbSize.width = kbSize.width / 1.8f;

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

// Reset the scroll view to the default location when the
// keyboard is hidden.
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

// Set the reference to the text field that should be
// focused on.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

// Remove the reference to the active textfield.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (IBAction)next:(id)sender {
    NSLog(@"heyyyyyyyyyyyss");
    [self performSegueWithIdentifier:@"regToDietRest" sender:self];
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

- (void)dealloc {
    // Compiler hint to remove any strong references to
    // registration view controller.
    self.locationPopoverController.delegate = nil;
    self.cityPopoverViewController.delegate = nil;
    self.genderPopoverViewController.delegate = nil;
    self.provincePopoverViewController.delegate = nil;
    self.birthdayPopoverViewController.delegate = nil;
    self.locationPopoverController = nil;
    self.cityPopoverViewController = nil;
    self.provincePopoverViewController = nil;
    self.genderPopoverViewController = nil;
    self.birthdayPopoverViewController = nil;
}

@end
