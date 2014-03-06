//
//  MMLoginManager.m
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import "MMLoginManager.h"
#import "MMDBFetcher.h"

NSString *const kCurrentUser = @"kCurrentUser";
NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginErrorNotification = @"kUserLoginErrorNotification";
NSString *const kGuestLogin = @"kGuestLogin";

@interface MMLoginManager() {
    MMDBFetcher *_dbFetcher;
    NSString *_userToLogin;
}

- (MMUser*)getLoggedInUser;

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

#pragma mark - Private Methods

- (MMUser*)getLoggedInUser {
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData *currentUserData = [perfs objectForKey:kCurrentUser];
    MMUser *currentUser = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUserData];
    
    return currentUser;
}

@end
