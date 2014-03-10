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
 * An abstract class that represents a validator that will compare
 * two text fields.
 */
@interface MMCompareTextFieldValidator : NSObject <MMValidatorProtocol>

/**
 * The first text field to be compared.
 */
@property(nonatomic, weak) UITextField *textField1;

/**
 * The second text field to be compared.
 */
@property(nonatomic, weak) UITextField *textField2;

/**
 * The validation message that will be shown if the
 * validation fails.
 */
@property(nonatomic, strong) NSString *errorMessage;

/**
 * Initializes a comparator validator with the text fields that are to
 * be compared and the validation error message to be shown if validation
 * fails.
 *
 * @param textField1 The first text field to compare.
 * @param textField2 The second text field to compare.
 * @param errorMessage The validation message to be shown if validation fails.
 *
 * @return The comparator validator.
 */
- (id)initWithFirstTextField:(UITextField *)textField1 withSecondTextField:(UITextField *)textField2 withValidationMessage:(NSString *)errorMessage;

@end
