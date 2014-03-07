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

#import "MMTextFieldValidator.h"

@implementation MMTextFieldValidator

- (id)initWithTextField:(UITextField *)textField withValidationMessage:(NSString *)errorMessage {
    self = [super init];
    
    if (self) {
        self.textField = textField;
        self.errorMessage = errorMessage;
    }
    
    return self;
}

- (BOOL)isValid {
    // Abstract method
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString*)getErrorMessage {
    return self.errorMessage;
}

@end
