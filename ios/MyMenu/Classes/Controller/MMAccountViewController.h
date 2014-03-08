//
//  MMAccountViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import <UIKit/UIKit.h>

/**
 *  Controller for the settings view
 */
@interface MMAccountViewController : UITableViewController


/**
 *  First Name View
 */
@property(nonatomic,weak) IBOutlet UITextField *givenNameField;

/**
 *  Last Name View
 */
@property(nonatomic,weak) IBOutlet UITextField *surnameField;

/**
 *  New Password View
 */
@property(nonatomic,weak) IBOutlet UITextField *updatedPasswordField;

/**
 *  Confirm New Password View
 */
@property(nonatomic,weak) IBOutlet UITextField *confirmPasswordField;

/**
 *  Default Location View
 */
@property(nonatomic,weak) IBOutlet UITextField *defaultLocationField;


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
