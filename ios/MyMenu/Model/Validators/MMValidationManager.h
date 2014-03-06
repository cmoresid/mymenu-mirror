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
 * A class that manages a list of objects that conforms to
 * `MMValidatorProtocol`. When you call the `performValidation:`
 * selector, the validation manager will iterate through its list
 * of validator objects and checks to see whether or not the validator
 * object is valid. Every validator object that is not in a valid state,
 * the validation message is returned.
 */
@interface MMValidationManager : NSObject

/**
 * Iterates through each of the validation objects and calls its
 * `isValid:` selector. For every object that fails validation, its
 * error message is added to an `NSArray` which holds all the validation
 * error messages.
 *
 * @return A list of `NSString` objects that represent the
 *         validation error messages.
 */
- (NSArray*)getValidationMessagesAsArray;

/**
 * Iterates through each of the validation objects and calls its
 * `isValid:` selector. For every object that fails validation, its
 * error message is added to an `NSArray` which holds all the validation
 * error messages; which is then converted into a string.
 *
 * @return A string representing the error messages.
 */
- (NSString*)getValidationMessagesAsString;

/**
 * Adds a validator object to the current validation manager.
 *
 * @param validator A validator object to be added to the validation manager.
 */
- (void)addValidator:(id<MMValidatorProtocol>)validator;

@end
