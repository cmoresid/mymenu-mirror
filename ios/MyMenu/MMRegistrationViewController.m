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
#import "MMRegistrationPopoverViewController.h"
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
    locationContent.popoverField = textField;

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

// Custom delegate method that allows for data transfer
// from a popover view controller to this view controller.
- (void)didSelectValue:(MMPopoverDataPair *)selectedValue {
    switch (selectedValue.dataType) {
        case CityValue:
            self.userProfile.city = selectedValue.selectedValue;
            break;
        case GenderValue:
            self.userProfile.gender = (selectedValue.selectedValue != nil)
                    ? [selectedValue.selectedValue characterAtIndex:0] : 'U';
            break;
        case ProvinceValue:
            self.userProfile.locality = selectedValue.selectedValue;
            break;
        case BirthdayValue: {
            // TODO: Refactor
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedValue.selectedValue];

            self.userProfile.birthday = [NSString stringWithFormat:@"%ld", (long) [components day]];
            self.userProfile.birthmonth = [NSString stringWithFormat:@"%ld", (long) [components month]];
            self.userProfile.birthyear = [NSString stringWithFormat:@"%ld", (long) [components year]];
            break;
        }
        default:
            break;
    }

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
    if (textField == self.cityField) {
        if (self.cityPopoverViewController == nil) {
            self.cityPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CityPopoverViewController"];
        }
        
        return self.cityPopoverViewController;
    }
    else if (textField == self.provinceField) {
        if (self.provincePopoverViewController == nil) {
            self.provincePopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProvincePopoverViewController"];
        }
        
        return self.provincePopoverViewController;
    }
    else if (textField == self.genderField) {
        if (self.genderPopoverViewController == nil) {
            self.genderPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GenderPopoverViewController"];
        }
        
        return self.genderPopoverViewController;
    }
    else if (textField == self.birthdayField) {
        if (self.birthdayPopoverViewController == nil) {
            self.birthdayPopoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayPopoverViewController"];
        }
        
        return self.birthdayPopoverViewController;
    }

    return nil;
}

// Set the popover view size depending on which text field
// is selected.
- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField {
    if (textField == self.birthdayField)
        return CGSizeMake(450.0f, 220.0f);
    else
        return CGSizeMake(350.0f, 200.0f);
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

    kbSize.height = kbSize.height / 2.1f;
    kbSize.width = kbSize.width / 2.1f;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"userInfoSegue"]) {
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
    self.cityPopoverViewController = nil;
    self.provincePopoverViewController = nil;
    self.genderPopoverViewController = nil;
    self.birthdayPopoverViewController = nil;
}

@end
