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

+ (id)get;

- (void)addUser:(MMUser *)user;

- (bool)userExists:(NSString *)email;

- (NSInteger)userVerified:(MMUser *)user;

- (NSArray *)getSpecials:(NSString *)day :(NSInteger)type;

- (void)addUserRestrictions:(NSString *)uid :(NSArray *)restrictions;

- (void)removeUserRestrictions:(NSString *)email;

- (NSArray *)getCompressedMerchants;

- (NSArray *)getMenu:(NSInteger *)merchid;

- (NSArray *)getAllRestrictions;

- (NSArray *)getUserRestrictions:(NSString *)email;

- (MMMerchant *)getMerchant:(NSInteger *)merchid;

@end