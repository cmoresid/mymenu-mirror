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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MMLocationManagerDelegate.h"

/**
 *  Represents a location manager error.
 */
extern NSString *const kMMLocationManagerDelegateErrorDomain;

/**
 *  Error that occurs when the location manager cannot
 *  retrieve a user's most recent location.
 */
extern const NSInteger ERR_MM_LMD_NO_MOST_RECENT_LOCATION;

/**
 *  Error that occurs when location services are disabled.
 */
extern const NSInteger ERR_MM_LMD_LOCATION_SERVICES_DENIED;

/**
 *  An implementation of the `MMLocationManagerDelegate`
 *  protocol. Tracks the user's current location.
 *
 *  @see `MMLocationManagerDelegate`
 */
@interface MMLocationManager : NSObject <MMLocationManagerDelegate>

/**
 *  Retrieves a singleton instance of 
 *  `MMLocationManager`
 *
 *  @return A single instance of `MMLocationManager`.
 */
+ (instancetype)sharedLocationManager;

@end
