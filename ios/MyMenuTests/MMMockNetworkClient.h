//
//  MMMockNetworkClient.h
//  MyMenu
//
//  Created by Connor Moreside on 2/6/2014.
//
//

#import <Foundation/Foundation.h>
#import "MMNetworkClientProtocol.h"

@interface MMMockNetworkClient : NSObject <MMNetworkClientProtocol>

- (id)initWithFakeResponse:(NSURLResponse*)response withFakeData:(NSString*)data withFakeError:(NSError*)error;

@end
