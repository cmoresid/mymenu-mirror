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

@interface MMDBFetcher : NSObject <NSURLConnectionDataDelegate>

- (void) addUser : (MMUser*) user;
- (bool) userExists : (NSString*) email;
- (bool) userVerified : (MMUser*) user;
- (NSArray*) getSpecials : (NSString*) day;
- (void) updatePreferences : (NSInteger*) uid : (NSArray*) restrictions;
- (NSArray*) getMerchants;


@end