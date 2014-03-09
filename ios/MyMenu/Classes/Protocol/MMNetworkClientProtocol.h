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

/**
 *  A callback block type that is used to
 *  represent a callback from a network
 *  call.
 *
 *  @param  The response object.
 *  @param  The data returned from a network call.
 *  @param  A potential error that may have occurred.
 */
typedef void (^NetworkResponseBlock)(NSURLResponse *, NSData *, NSError *);

/**
 *  Provides an intermediate layer (service layer) to 
 *  decouple the mechanism to retrieve information from
 *  a server from the intent to retrieve information from
 *  the server. This allows for mocking or allows you to
 *  swap out the object that actually performs a service
 *  call. i.e. Swap out `NSURLConnection` with AFNetwork for
 *  example.
 */
@protocol MMNetworkClientProtocol <NSObject>

/**
 *  Represents the intent to retrieve data from
 *  a server.
 *
 *  @param request         The request object.
 *  @param completionBlock The callback block that is
 *                         to be called when network call
 *                         returns.
 */
- (void)performNetworkRequest:(NSMutableURLRequest *)request completionHandler:(NetworkResponseBlock)completionBlock;

@end