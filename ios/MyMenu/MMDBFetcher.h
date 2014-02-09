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
#import "MMUser.h"
#import "MMRestriction.h"
#import "MMSpecial.h"
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMNetworkClientProtocol.h"

@class CLLocation;

/**
* A model for qeurying data from the api.
*/
@interface MMDBFetcher : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) id<MMDBFetcherDelegate> delegate;
@property(nonatomic, strong) id<MMNetworkClientProtocol> networkClient;

/**
* Get a singleton instance of this class.
* Clients should use this, and not initialize a new instance for every request.
*
* NOTE: The idea is to encapsulate request merging in this class, so a singleton will give us
* significant performance improvements.
*
*/
+ (MMDBFetcher*)get;

- (id)initWithNetworkClient:(id<MMNetworkClientProtocol>)client;

/**
* Add a user to the service.
*/
- (void)addUser:(MMUser *)user;

/**
* Check if the user with this email address exists already.
*/
- (void)userExists:(NSString *)email;

/**
* Checks if the password for the user is entered correctly (for login).
*/
- (void)userVerified:(MMUser *)user;

/**
* Get specials for the given day of the given type.
*/

//- (NSArray *)getSpecials:(NSString *)day :(NSInteger)type;
- (void)getSpecials:(NSString *)day withType:(NSInteger)type;

/**
* Add all given restrictions for the given user.
*/
- (void)addUserRestrictions:(NSString *)email :(NSArray *)restrictions;

/**
* Get all merchants. Only return a subset of the fields to minify data.
*
* TODO: filter by nearby
*/
//- (NSArray *)getCompressedMerchants;
- (void)getCompressedMerchants:(CLLocation*) usrloc;

/**
* Get the menu for the restaurant.
*/
- (void)getMenuWithMerchantId:(NSInteger)merchid withUserEmail:(NSString*)email;

/**
* Get all restrictions that we support.
*/
- (void)getAllRestrictions;

/**
* Get all restrictions for the given user.
*/
- (void)getUserRestrictions:(NSString *)email;

/**
* Get all information about the merchant (restaurant) with the given id.
*/
- (void)getMerchant:(NSNumber *)merchid;

/**
* Edit the given user's information on the server.
*/
- (void)editUser:(MMUser *)user;

/**
* Get all information for the user with the given email.
*/
- (void)getUser:(NSString *)email;

@end