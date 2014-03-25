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

@class MMValidationManager;
@class MMUserNameValidator;

/**
 
 This view allows a user to provide additional information for their profile.
 We provide the user with options to fill in their city, gender, birthday.
 */
@interface MMRegistrationViewController : UITableViewController <UITextFieldDelegate, UIPopoverControllerDelegate, MMRegistrationPopoverDelegate>

/**
 *  Users chosen email textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *emailField;
/**
 *  Users chosen password textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *passwordField;
/**
 *  Users chosen password confirm textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *confirmPasswordField;
/**
 *  Users chosen first name textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *firstNameField;
/**
 *  Users chosen last name textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *lastNameField;
/**
 *  Users chosen city textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *cityField;
/**
 *  Users chosen province textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *provinceField;
/**
 *  Users chosen gender textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *genderField;
/**
 *  Users chosen birthday textfield
 */
@property(nonatomic, weak) IBOutlet UITextField *birthdayField;
/**
 *  The scroll view to move the view up for the keyboard
 */
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
/**
 *  Current selected UITextField
 */
@property(nonatomic, weak) IBOutlet UITextField *activeField;

/**
 *  The UIPopover controller
 */
@property(nonatomic, strong) UIPopoverController *locationPopoverController;

/**
 *  City Popover
 */
@property(nonatomic, strong) MMRegistrationPopoverViewController *cityPopoverViewController;

/**
 *  Province Popover
 */
@property(nonatomic, strong) MMRegistrationPopoverViewController *provincePopoverViewController;

/**
 *  Gener Popover
 */
@property(nonatomic, strong) MMRegistrationPopoverViewController *genderPopoverViewController;

/**
 *  Birthday Popover
 */
@property(nonatomic, strong) MMRegistrationPopoverViewController *birthdayPopoverViewController;

/**
 *  The current user that we are "creating"
 */
@property(readwrite) MMUser *userProfile;

/**
 *  Validates the form (MMUser)
 */
@property(nonatomic, strong) MMValidationManager *validationManager;

/**
 *  used to check if the username is valid, and avaliable.
 */
@property(nonatomic, strong) MMUserNameValidator *userNameValidator;


/**
 *  Back button
 *
 *  @param segue UIStoryboardSegue
 */
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue;

/**
 *  Next Button
 *
 *  @param sender UIButton
 */
- (IBAction)next:(id)sender;

/**
 *  Returns the popover for the selected textfield, if needed
 *
 *  @param textField UITextField
 *
 *  @return Returns the view controller for the UITextField
 */
- (id)getPopoverViewControllerForTextField:(UITextField *)textField;

/**
 *  Returns the size needed for the popover
 *
 *  @param textField UITextField
 *
 *  @return CGSize needed to show all content.
 */
- (CGSize)getPopoverViewSizeForTextField:(UITextField *)textField;

@end
