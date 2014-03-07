//
//  MMNetworkRequest.h
//  MyMenu
//
//  Created by Connor Moreside on 2/6/2014.
//
//

#import <Foundation/Foundation.h>

typedef void (^NetworkResponseBlock)(NSURLResponse *, NSData *, NSError *);

@protocol MMNetworkClientProtocol <NSObject>

- (void)performNetworkRequest:(NSMutableURLRequest *)request completionHandler:(NetworkResponseBlock)completionBlock;

@end