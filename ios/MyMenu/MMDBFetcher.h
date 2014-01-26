//
//  MMDBFetcher.h
//  MyMenu
//
//  Created by Chris Moulds on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMUser.h"
#import "MMRestriction.h"
#import "MMSpecial.h"
#import "MMMerchant.h"

@interface MMDBFetcher : NSObject <NSURLConnectionDataDelegate>

- (void) addUser : (MMUser*) user;
- (bool) userExists : (NSString*) email;
- (NSInteger) userVerified : (MMUser*) user;
- (NSArray*) getSpecials : (NSString*) day;
- (void) updateUserRestrictions : (NSInteger*) uid : (NSArray*) restrictions;
- (NSArray*) getCompressedMerchants;
- (NSArray*) getMenu : (NSInteger*) merchid;
- (NSArray*) getAllRestrictions;
- (NSArray*) getUserRestrictions : (NSInteger*) uid;
- (MMMerchant*) getMerchant : (NSInteger*) merchid;

@end