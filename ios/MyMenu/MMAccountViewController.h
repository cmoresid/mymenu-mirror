//
//  MMAccountViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import <UIKit/UIKit.h>

@interface MMAccountViewController : UITableViewController

@property(nonatomic,weak) IBOutlet UITextField *givenNameField;
@property(nonatomic,weak) IBOutlet UITextField *surnameField;
@property(nonatomic,weak) IBOutlet UITextField *updatedPasswordField;
@property(nonatomic,weak) IBOutlet UITextField *confirmPasswordField;
@property(nonatomic,weak) IBOutlet UITextField *defaultLocationField;

- (IBAction)updatePassword:(id)sender;
- (IBAction)updateDefaultLocation:(id)sender;
- (IBAction)logout:(id)sender;

@end
