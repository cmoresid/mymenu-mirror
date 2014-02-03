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

#import <UIKit/UIKit.h>
#import "MMRegistrationPopoverViewController.h"
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

@property(nonatomic, strong) MMRegistrationPopoverViewController *cityPopoverViewController;
@property(nonatomic, strong) MMRegistrationPopoverViewController *provincePopoverViewController;
@property(nonatomic, strong) MMRegistrationPopoverViewController *genderPopoverViewController;
@property(nonatomic, strong) MMRegistrationPopoverViewController *birthdayPopoverViewController;

@property(readwrite) MMUser *userProfile;

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue;

- (id)getPopoverViewControllerForTextField:(UITextField *)textField;

- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField;

@end
