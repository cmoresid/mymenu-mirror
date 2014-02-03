//
//  MMDBFetcherDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 2/1/2014.
//
//

#import <Foundation/Foundation.h>
#import "MMDBFetcherResponse.h"
#import "MMUser.h"
#import "MMMerchant.h"


@protocol MMDBFetcherDelegate <NSObject>

@optional
- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse*)response;
- (void)doesUserExist:(BOOL)exists withResponse:(MMDBFetcherResponse*)response;
- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveUser:(MMUser*)user withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveSpecials:(NSArray*)specials withResponse:(MMDBFetcherResponse*)response;
- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse*)response;
- (void)didRemoveAllUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveCompressedMerchants:(NSArray*)compressedMerchants withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveMenuItems:(NSArray*)menuItems withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveAllRestrictions:(NSArray*)allRestrictions withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveUserRestrictions:(NSArray*)userRestrictions withResponse:(MMDBFetcherResponse*)response;
- (void)didRetrieveMerchant:(MMMerchant*)merchant withResponse:(MMDBFetcherResponse*)response;
- (void)didUpdateUser:(BOOL)successful withResponse:(MMDBFetcherResponse*)response;


@end
