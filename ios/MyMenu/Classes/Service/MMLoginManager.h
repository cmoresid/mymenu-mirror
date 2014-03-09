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
 *  A singleton class that is used to manage the user's
 *  login state. This class provides methods to log a 
 *  user in, log a user out, login as guest, and retrieve
 *  the current logged in user.
 */
@interface MMLoginManager : NSObject <MMDBFetcherDelegate>

/**
 *  Retrieve the singleton for the `MMLoginManager`.
 *
 *  @return Retrieve the singleton.
 */
+ (id)sharedLoginManager;

/**
 *  Begin an asynchronous call to log a user in. First,
 *  it checks to see if the user name exists on the server,
 *  then it verifies the user's password.
 *
 *  @param userName The user name to login.
 *  @param password The user's password.
 */
- (void)beginLoginWithUserName:(NSString*)userName withPassword:(NSString*)password;

/**
 *  Serializes the specifid user's profile to 
 *  the device.
 *
 *  @param user The `MMUser` profile to save to
 *              the device.
 */
- (void)saveUserProfileToDevice:(MMUser*)user;

/**
 *  Removes the current user profile from the
 *  device, which has the effect of logging the
 *  user out.
 */
- (void)logoutUser;

/**
 *  Checks to see if the user is logged in.
 *
 *  @return Returns whether or not a user is
 *          logged in.
 */
- (BOOL)isUserLoggedIn;

/**
 *  Logs a user in as a guest. All this does is
 *  create a `MMUser` object with it's email property
 *  set to "kGuest".
 */
- (void)loginAsGuest;

/**
 *  Checks to see if a user is logged in as
 *  guest.
 *
 *  @return Returns whether or not a user is
 *          logged in as a guest.
 */
- (BOOL)isUserLoggedInAsGuest;

/**
 *  Returns the user profile of the user that
 *  is currently logged in.
 *
 *  @return An `MMUser` object that represents
 *          the user that is currently logged
 *          in.
 */
- (MMUser*)getLoggedInUser;

/**
 *  Starts an asynchronous to update a user's
 *  profile.
 *
 *  @param userToUpdate The user profile to update.
 */
- (void)beginUpdateUser:(MMUser*)userToUpdate;

@end
