//
//  MMMockDBFetcherDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 2/5/2014.
//
//

#import <Foundation/Foundation.h>
#import "MMDBFetcherDelegate.h"

@class MMDBFetcherResponse;
@class MMMerchant;
@class MMUser;

typedef void (^BooleanResponseBlock)(BOOL, MMDBFetcherResponse*);
typedef void (^ArrayResponseBlock)(NSArray*, MMDBFetcherResponse*);
typedef void (^IntegerResponseBlock)(NSInteger, MMDBFetcherResponse*);
typedef void (^MerchantResponseBlock)(MMMerchant*, MMDBFetcherResponse*);
typedef void (^UserResponseBlock)(MMUser*, MMDBFetcherResponse*);

@interface MMMockDBFetcherDelegate : NSObject <MMDBFetcherDelegate>

@property(nonatomic, copy) MerchantResponseBlock merchantResponseCallback;
@property(nonatomic, copy) UserResponseBlock userResponseCallback;

@end
