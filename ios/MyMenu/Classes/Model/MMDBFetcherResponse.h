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

#import <Foundation/Foundation.h>

/**
 * An class that is used by `MMDBFetcher` that
 * is used to encapsulate the response from the
 * server.
 */
@interface MMDBFetcherResponse : NSObject

/**
 * Represents whether or not a service
 * call was successful.
 */
@property(atomic) BOOL wasSuccessful;

/**
 * A list of any error messages returned
 * by the service call.
 */
@property(atomic) NSMutableArray *messages;

@end
