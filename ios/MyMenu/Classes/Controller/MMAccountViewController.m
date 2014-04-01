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

#import "MMAccountViewController.h"
#import "MMLoginManager.h"
#import "MMUser.h"
#import "MMValidator.h"
#import "MMValidationManager.h"
#import "MMSplitViewManager.h"
#import "MMTextField.h"
#import "MMRegistrationPopoverViewController.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"
#import "UIColor+MyMenuColors.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMAccountViewController ()

- (void)registerForUpdateUserNotifications;
- (void)unregisterForUpdateUserNotifications;
- (void)updateUser:(NSNotification *)notification;
- (void)updateUserError:(NSNotification *)notification;

@end

@implementation MMAccountViewController

#pragma mark - Custom Accessor Methods

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem {
    if (navigationPaneBarButtonItem == _navigationPaneBarButtonItem)
        return;
    
    if (navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
    else
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
}

#pragma mark - View Controller Methods

- (void)configureNavigationItems {
    self.navigationItem.title = NSLocalizedString(@"Account Information", nil);
    
    if (self.navigationPaneBarButtonItem) {
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem
                                         animated:NO];
    }
}

- (void)populateFieldsFromLoggedInUser {
    MMUser *loggedInUser = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    self.emailAddressField.text = loggedInUser.email;
    self.givenNameField.text = loggedInUser.firstName;
    self.surnameField.text = loggedInUser.lastName;
    
    self.emailAddressField.enabled = NO;
    self.givenNameField.enabled = NO;
    self.surnameField.enabled = NO;
    
    self.defaultCity.placeholder = loggedInUser.city;
    self.defaultLocality.placeholder = loggedInUser.locality;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureDelegates];
    
    [self configureDataBindings];
    [self configureNavigationItems];
    [self populateFieldsFromLoggedInUser];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForUpdateUserNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self unregisterForUpdateUserNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate Methods

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self createPopoverForTextField:textField]) {
        return YES;
    }
    
    MMRegistrationPopoverViewController *locationContent = [self getPopoverViewControllerForTextField:textField];
    locationContent.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:locationContent];
    
    popover.popoverContentSize = CGSizeMake(350.0f, 200.0f);
    popover.delegate = self;
    
    self.locationPopoverController = popover;
    
    [self.locationPopoverController presentPopoverFromRect:textField.frame
                                                    inView:textField.superview
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
    
    return FALSE;
}

- (BOOL)createPopoverForTextField:(UITextField *)textField {
    return (textField == self.defaultLocality || textField == self.defaultCity);
}

- (MMRegistrationPopoverViewController *)getPopoverViewControllerForTextField:(UITextField *)textField {
    MMRegistrationPopoverViewController *registrationPopover = nil;
    
    if (textField == self.defaultCity) {
        registrationPopover = [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"CityPopoverViewController"];
    }
    else if (textField == self.defaultLocality) {
        registrationPopover = [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"ProvincePopoverViewController"];
    }
    
    return registrationPopover;
}

#pragma mark - MMRegistrationPopoverViewController Delegate Methods

- (void)didSelectCity:(NSString *)city {
    self.defaultCity.text = city;
    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectProvince:(NSString *)province {
    self.defaultLocality.text = province;
    [self.locationPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - Popover Controller Delegate Methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return NO;
}

#pragma mark - Register Notification Methods

- (void)registerForUpdateUserNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser:)
                                                 name:kUserUpdatedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserError:)
                                                 name:kUserUpdateErrorNotification
                                               object:nil];
}

- (void)unregisterForUpdateUserNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserUpdatedNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserUpdateErrorNotification
                                                  object:nil];
}

#pragma mark - Update User Notification Callback Methods

- (void)updateUser:(NSNotification *)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    self.defaultCity.text = nil;
    self.defaultLocality.text = nil;

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                      message:NSLocalizedString(@"Update Successful.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [message show];
}

- (void)updateUserError:(NSNotification *)notification {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                      message:NSLocalizedString(@"Unable to update information.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - Action Methods

- (IBAction)updatePassword:(id)sender {
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    userToUpdate.password = self.confirmPasswordField.text;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[[MMLoginManager sharedLoginManager] changePasswordForUser:userToUpdate]
        subscribeNext:^(NSNumber *result) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            self.confirmPasswordField.text = @"";
            self.updatedPasswordField.text = @"";
            
            [self.confirmPasswordField resignFirstResponder];
            [self.updatedPasswordField resignFirstResponder];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                              message:NSLocalizedString(@"Successfully updated your password.", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            [message show];
        }
        error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                              message:NSLocalizedString(@"Unable to update your password.", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            [message show];
    }];
}

- (IBAction)updateDefaultLocation:(id)sender {
    MMUser *userToUpdate = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    userToUpdate.city = (self.defaultCity.text.length > 0) ? self.defaultCity.text : userToUpdate.city;
    userToUpdate.locality = (self.defaultLocality.text.length > 0) ? self.defaultLocality.text : userToUpdate.locality;

    self.defaultCity.placeholder = userToUpdate.city;
    self.defaultLocality.placeholder = userToUpdate.locality;
    
    [self.updatedPasswordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MMLoginManager sharedLoginManager] beginUpdateUser:userToUpdate];
}

- (IBAction)logout:(id)sender {
    [[MMLoginManager sharedLoginManager] logoutUser];
    [self.splitViewController performSegueWithIdentifier:@"userMustLogin" sender:self];
}

#pragma mark - Private Helper Methods

- (void)configureDataBindings {
    RAC(self.changePasswordButton, enabled) =
        [RACSignal
            combineLatest:@[self.updatedPasswordField.rac_textSignal, self.confirmPasswordField.rac_textSignal]
            reduce:^(NSString *updatedPassword, NSString *confirmPassword) {
                return @([updatedPassword isEqualToString:confirmPassword] && ![updatedPassword isEqualToString:@""]);
    }];
    
    RAC(self.changePasswordButton, backgroundColor) =
        [RACObserve(self.changePasswordButton, enabled)
            map:^UIColor *(NSNumber *enabled) {
                return [enabled isEqualToNumber:@YES] ? [UIColor tealColor] : [UIColor lightGrayColor];
    }];
    
    RAC(self.updateLocationButton, enabled) =
        [RACSignal
            combineLatest:@[RACObserve(self.defaultLocality, text), RACObserve(self.defaultCity, text)]
            reduce:^(NSString *defaultLocality, NSString *defaultCity) {
                return @(defaultLocality.length > 0 || defaultCity.length > 0 );
    }];
    
    RAC(self.updateLocationButton, backgroundColor) =
        [RACObserve(self.updateLocationButton, enabled)
         map:^UIColor *(NSNumber *enabled) {
             return [enabled isEqualToNumber:@YES] ? [UIColor tealColor] : [UIColor lightGrayColor];
    }];
}

- (void)configureDelegates {
    self.updatedPasswordField.delegate = self;
    self.confirmPasswordField.delegate = self;
    self.defaultCity.delegate = self;
    self.defaultLocality.delegate = self;
}

@end
