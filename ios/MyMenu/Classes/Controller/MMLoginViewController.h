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
#import "MMDBFetcherDelegate.h"

@class MMValidationManager;

/**
 Login view controller.
 A view controller that logs in a user.
 User is prompted for their email address (id) and their password.
 */
@interface MMLoginViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UITextField *emailAddress;
@property(nonatomic, weak) IBOutlet UITextField *password;
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UITextField *activeField;

- (IBAction)login:(id)sender;
- (IBAction)loginAsGuest:(id)sender;

@end