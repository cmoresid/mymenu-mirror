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

#import "MMLoginManager.h"
#import "MMDBFetcher.h"

NSString *const kCurrentUser = @"kCurrentUser";
NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginErrorNotification = @"kUserLoginErrorNotification";
NSString *const kGuestLogin = @"kGuestLogin";
NSString *const kUserUpdatedNotification = @"kUserUpdatedNotification";
NSString *const kUserUpdateErrorNotification = @"kUserUpdateErrorNotification";

@interface MMLoginManager() {
    MMDBFetcher *_dbFetcher;
    NSString *_userToLogin;
    MMUser *_userToUpdate;
}

@end

@implementation MMLoginManager

static MMLoginManager *instance;

#pragma mark - Initializers

- (id)init {
    self = [super init];
    
    if (self) {
        _dbFetcher = [[MMDBFetcher alloc] init];
        _dbFetcher.delegate = self;
    }
    
    return self;
}

+ (id)sharedLoginManager {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

#pragma mark - Login Manager Methods

- (void)beginLoginWithUserName:(NSString *)userName withPassword:(NSString *)password {
    MMUser *userToLogin = [[MMUser alloc] init];
    userToLogin.email = userName;
    userToLogin.password = password;
    
    _userToLogin = userName;
    
    [_dbFetcher userVerified:userToLogin];
}

- (void)logoutUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];
}

- (BOOL)isUserLoggedIn {
    return ([self getLoggedInUser] != nil);
}

- (void)loginAsGuest {
    MMUser *user = [MMUser new];
    user.email = kGuestLogin;
    
    // Store user object now
    NSUserDefaults *userPreferances = [NSUserDefaults standardUserDefaults];
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userPreferances setObject:encodedUser forKey:kCurrentUser];
}

- (BOOL)isUserLoggedInAsGuest {
    return ([[self getLoggedInUser].email isEqualToString:kGuestLogin]);
}

- (MMUser*)getLoggedInUser {
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData *currentUserData = [perfs objectForKey:kCurrentUser];
    MMUser *currentUser = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUserData];
    
    return currentUser;
}

- (void)beginUpdateUser:(MMUser *)userToUpdate {
    _userToUpdate = userToUpdate;
    
    [_dbFetcher editUser:userToUpdate];
}

- (void)saveUserProfileToDevice:(MMUser*)user {
    NSUserDefaults *userPreferances = [NSUserDefaults standardUserDefaults];
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userPreferances setObject:encodedUser forKey:kCurrentUser];
}

#pragma mark - Delegate Methods Implemented

- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginErrorNotification
                                                            object:nil];
        return;
    }
    
    if (resultCode > 0) {
        [_dbFetcher getUser:_userToLogin];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
    }
}

- (void)didRetrieveUser:(MMUser *)user withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginErrorNotification object:nil];
    }
    
    // Store user object now
    NSUserDefaults *userPreferances = [NSUserDefaults standardUserDefaults];
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userPreferances setObject:encodedUser forKey:kCurrentUser];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                        object:user];
}

- (void)didUpdateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
    if (!response.wasSuccessful) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateErrorNotification
                                                            object:nil];
        return;
    }
    
    if (successful) {
        // Save updated user.
        NSUserDefaults *userPreferances = [NSUserDefaults standardUserDefaults];
        NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:_userToUpdate];
        [userPreferances setObject:encodedUser forKey:kCurrentUser];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdatedNotification
                                                            object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateErrorNotification
                                                            object:nil];
    }
}

@end
