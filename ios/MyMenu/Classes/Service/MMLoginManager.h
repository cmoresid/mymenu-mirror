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
#import "MMDBFetcherDelegate.h"

/**
 *  Notification identifer that refers to the notification 
 *  that is sent when a user is logged.
 */
extern NSString *const kUserLoginNotification;

/**
 *  Notification identifer that refers to the notification
 *  that is sent when a user login error occurs. Generally,
 *  this would be due to a network error.
 */
extern NSString *const kUserLoginErrorNotification;

/**
 *  Notification identifer that refers to the notification
 *  that is sent when a user profile has been updated.
 */
extern NSString *const kUserUpdatedNotification;

/**
 *  Notification identifer that refers to the notification
 *  that is sent when a user profile cannot be updated due
 *  to an error. Generally, this is due to a network error.
 */
extern NSString *const kUserUpdateErrorNotification;

/**
 *  <#Description#>
 */
@interface MMLoginManager : NSObject <MMDBFetcherDelegate>

+ (id)sharedLoginManager;
- (void)beginLoginWithUserName:(NSString*)userName withPassword:(NSString*)password;
- (void)saveUserProfileToDevice:(MMUser*)user;
- (void)logoutUser;
- (BOOL)isUserLoggedIn;
- (void)loginAsGuest;
- (BOOL)isUserLoggedInAsGuest;
- (MMUser*)getLoggedInUser;
- (void)beginUpdateUser:(MMUser*)userToUpdate;

@end
