//
//  MMLoginManager.h
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import <Foundation/Foundation.h>
#import "MMDBFetcherDelegate.h"

extern NSString *const kUserLoginNotification;
extern NSString *const kUserLoginErrorNotification;
extern NSString *const kUserUpdatedNotification;
extern NSString *const kUserUpdateErrorNotification;

@interface MMLoginManager : NSObject <MMDBFetcherDelegate>

+ (id)sharedLoginManager;
- (void)beginLoginWithUserName:(NSString*)userName withPassword:(NSString*)password;
- (void)logoutUser;
- (BOOL)isUserLoggedIn;
- (void)loginAsGuest;
- (BOOL)isUserLoggedInAsGuest;
- (MMUser*)getLoggedInUser;
- (void)beginUpdateUser:(MMUser*)userToUpdate;

@end
