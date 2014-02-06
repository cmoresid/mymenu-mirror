//
//  MMNetworkRequestProxy.m
//  MyMenu
//
//  Created by Connor Moreside on 2/6/2014.
//
//

#import "MMNetworkClientProxy.h"

@implementation MMNetworkRequestProxy

- (void)performNetworkRequest:(NSMutableURLRequest*)request completionHandler:(NetworkResponseBlock)completionBlock {
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:completionBlock];
}

@end
