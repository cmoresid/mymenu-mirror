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

#import "MMValidationManager.h"
#import "MMValidator.h"

@interface MMValidationManager()

@property NSMutableArray *validationMessages;
@property NSMutableArray *validationObjects;

@end

@implementation MMValidationManager

- (id)init {
    self = [super init];
    
    if (self) {
        self.validationObjects = [NSMutableArray new];
    }
    
    return self;
}

- (NSArray*)performValidation {
    self.validationMessages = [NSMutableArray new];
    
    for (id<MMValidatorProtocol> validator in self.validationObjects) {
        if (![validator isValid]) {
            [self.validationMessages addObject:[validator getErrorMessage]];
        }
    }
    
    return [self.validationMessages copy];
}

- (void)addValidator:(id<MMValidatorProtocol>)validator {
    [self.validationObjects addObject:validator];
}

@end
