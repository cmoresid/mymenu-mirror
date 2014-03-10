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

#import <Foundation/Foundation.h>
#import "MMDBFetcherDelegate.h"

/**
 * A constant that refers to a notification that
 * is sent once validation against the server
 * occurs.
 */
extern NSString *const kAvailableUserNameNotification;

/**
 * A concrete validator that checks the server to see if
 * a user name is available.
 */
@interface MMUserNameValidator : NSObject <MMDBFetcherDelegate>

/**
 * A text field that contains the user name to be validated.
 */
@property(nonatomic, weak) UITextField *userNameTextField;

/**
 * A constructor that accepts a text field which contains
 * a user name to be validated
 *
 * @param textField The text field that will contain the user name to be validated.
 */
- (id)initWithUserNameTextField:(UITextField *)textField;

/**
 * Begins an asynchronous request to validate the user name
 * against the server database. A notification is posted to
 * the default notification center once the validation is
 * completed. The notification name is stored in
 * `kAvailableUserNameNotification`.
 */
- (void)beginValidation;

@end
