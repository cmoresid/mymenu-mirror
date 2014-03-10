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

#import "MMUserNameValidator.h"
#import "MMDBFetcher.h"

NSString *const kAvailableUserNameNotification = @"kAvailableUserNameNotification";

@interface MMUserNameValidator () {
    MMDBFetcher *_dbFetcher;
}

@end

@implementation MMUserNameValidator

- (id)initWithUserNameTextField:(UITextField *)textField {
    self = [super init];

    if (self) {
        self.userNameTextField = textField;
        _dbFetcher = [[MMDBFetcher alloc] init];
        _dbFetcher.delegate = self;
    }

    return self;
}

- (void)beginValidation {
    [_dbFetcher userExists:self.userNameTextField.text];
}

- (void)doesUserExist:(BOOL)exists withResponse:(MMDBFetcherResponse *)response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableUserNameNotification object:[NSNumber numberWithBool:exists]];
}

@end
