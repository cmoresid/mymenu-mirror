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
#import "MMValidatorProtocol.h"

/**
 * An abstract validator that allows validation to be performed on
 * a single text field.
 */
@interface MMTextFieldValidator : NSObject <MMValidatorProtocol>

/**
 * The text field to be validated.
 */
@property(nonatomic, weak) UITextField *textField;

/**
 * The validation message to be shown if validation fails.
 */
@property(nonatomic, strong) NSString *errorMessage;

/**
 * A constructor that initializes a validator object with a text field and a validation
 * message.
 *
 * @param textField The text field to be validated.
 * @param errorMessage The validation message to be shown if validation fails.
 */
- (id)initWithTextField:(UITextField *)textField withValidationMessage:(NSString *)errorMessage;

@end
