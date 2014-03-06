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
#import "MMTextFieldValidator.h"

/**
 * A concrete validator that checks to see if the contents
 * of the text field matches a given regular expression.
 */
@interface MMRegexTextFieldValidator : MMTextFieldValidator

/**
 * A string represention of a regular expression that
 * is to be used to validate the contents of a text field.
 */
@property (nonatomic, strong) NSString *regex;

/**
 * A constructor that accepts a text field to validate, a regular expression string,
 * and the corresponding validation message.
 *
 * @param textField The text field to be validated.
 * @param regex The regular expression that is to be used to validate the text field.
 * @param errorMessage The validation message to be shown if text field contents are invalid.
 *
 */
- (id)initWithTextField:(UITextField*)textField withRegexString:(NSString*)regex withValidationMessage:(NSString*)errorMessage;

@end
