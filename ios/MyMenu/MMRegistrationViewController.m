//
//  MMRegistrationViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMRegistrationViewController.h"
#import "MMRegistrationPopoverViewController.h"
#import "MMDietaryRestrictionsViewController.h"
#import <Foundation/Foundation.h>

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
    // Do any additional setup after loading the view.
    //self.emailField.delegate = self;
    //self.passwordField.delegate = self;
    //self.confirmPasswordField.delegate = self;
    self.cityField.delegate = self;
    self.genderField.delegate = self;
    self.provinceField.delegate = self;
    self.birthdayField.delegate = self;

    self.userProfile = [[MMUser alloc] init];
    [self registerForKeyboardNotifications];
    [self.emailField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    NSLog(@"Dismiss...");
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

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
        case BirthdayValue:
        {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedValue.selectedValue];
        
            self.userProfile.birthday = [NSString stringWithFormat:@"%ld", (long)[components day]];
            self.userProfile.birthmonth = [NSString stringWithFormat:@"%ld", (long)[components month]];
            self.userProfile.birthyear = [NSString stringWithFormat:@"%ld", (long)[components year]];
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

- (id)getPopoverViewControllerForTextField:(UITextField *)textField {
    if (textField == self.cityField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"CityPopoverViewController"];
    else if (textField == self.provinceField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"ProvincePopoverViewController"];
    else if (textField == self.genderField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"GenderPopoverViewController"];
    else if (textField == self.birthdayField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayPopoverViewController"];

    return nil;
}

- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField {
    if (textField == self.birthdayField)
        return CGSizeMake(450.0f, 220.0f);
    else
        return CGSizeMake(350.0f, 200.0f);
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
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
    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"userInfoSegue"]) {
        self.userProfile.email = self.emailField.text;
        self.userProfile.password = self.passwordField.text;
        self.userProfile.firstName = self.firstNameField.text;
        self.userProfile.lastName = self.lastNameField.text;
        self.userProfile.country = @"CAN";
        
        MMDietaryRestrictionsViewController *destinationController = [segue  destinationViewController];
        
        destinationController.userProfile = self.userProfile;
    }
}

@end
