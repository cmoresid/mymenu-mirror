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
#import "MMSplitViewManager.h"

@class MMSplitViewManager;

/**
 *  Controller for the settings view
 */
@interface MMAccountViewController : UITableViewController <MMDetailViewController, UITextFieldDelegate>

/**
 *
 */
@property(nonatomic, weak) IBOutlet UITextField *emailAddressField;

/**
 *  First Name View
 */
@property(nonatomic, weak) IBOutlet UITextField *givenNameField;

/**
 *  Last Name View
 */
@property(nonatomic, weak) IBOutlet UITextField *surnameField;

/**
 *  New Password View
 */
@property(nonatomic, weak) IBOutlet UITextField *updatedPasswordField;

/**
 *  Confirm New Password View
 */
@property(nonatomic, weak) IBOutlet UITextField *confirmPasswordField;

/**
 *  Default Location View
 */
@property(nonatomic, weak) IBOutlet UITextField *defaultCity;

@property(nonatomic, weak) IBOutlet UITextField *defaultLocality;

@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

/**
 *  Saves the users new password
 *
 *  @param sender
 */
- (IBAction)updatePassword:(id)sender;

/**
 *  Saves the users new locations
 *
 *  @param sender
 */
- (IBAction)updateDefaultLocation:(id)sender;

/**
 *  Logs the current user out.
 *
 *  @param sender
 */
- (IBAction)logout:(id)sender;

@end
