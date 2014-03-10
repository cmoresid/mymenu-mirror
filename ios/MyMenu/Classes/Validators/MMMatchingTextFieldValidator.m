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

#import "MMMatchingTextFieldValidator.h"

@implementation MMMatchingTextFieldValidator

- (id)initWithFirstTextField:(UITextField *)textField1 withSecondTextField:(UITextField *)textField2 withValidationMessage:(NSString *)errorMessage {
    self = [super initWithFirstTextField:textField1 withSecondTextField:textField2 withValidationMessage:errorMessage];

    return self;
}

- (BOOL)isValid {
    return [self.textField1.text isEqualToString:self.textField2.text];
}

@end
