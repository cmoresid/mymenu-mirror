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

/**
 * An interface that describes a validator object. If you wish to
 * validate the state of an object, create a new class that conforms
 * to this protocol.
 */
@protocol MMValidatorProtocol <NSObject>

/**
 * Returns whether or not the state of the object that is represented
 * by the validator object is valid.
 */
- (BOOL)isValid;

/**
 * Retrieves any error message that is contained within the
 * validator object.
 */
- (NSString *)getErrorMessage;

@end
