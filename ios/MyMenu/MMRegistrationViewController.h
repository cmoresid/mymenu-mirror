//
//  MMRegistrationViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRegistrationPopoverDelegate.h"
#import "MMUser.h"

@interface MMRegistrationViewController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate, MMRegistrationPopoverDelegate>

@property(nonatomic, weak) IBOutlet UITextField *emailField;
@property(nonatomic, weak) IBOutlet UITextField *passwordField;
@property(nonatomic, weak) IBOutlet UITextField *confirmPasswordField;
@property(nonatomic, weak) IBOutlet UITextField *firstNameField;
@property(nonatomic, weak) IBOutlet UITextField *lastNameField;
@property(nonatomic, weak) IBOutlet UITextField *cityField;
@property(nonatomic, weak) IBOutlet UITextField *provinceField;
@property(nonatomic, weak) IBOutlet UITextField *genderField;
@property(nonatomic, weak) IBOutlet UITextField *birthdayField;
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UITextField *activeField;

@property(nonatomic, strong) UIPopoverController *locationPopoverController;
@property(readwrite) MMUser *userProfile;

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue;

- (id)getPopoverViewControllerForTextField:(UITextField *)textField;

- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField;


@end
