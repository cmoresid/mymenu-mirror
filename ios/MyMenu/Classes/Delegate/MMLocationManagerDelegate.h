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
#import <CoreLocation/CLLocationManagerDelegate.h>

@class RACSignal;
@class CLLocationManager;

/**
 *  Delegate interface that defines a class that
 *  will track a user's location.
 */
@protocol MMLocationManagerDelegate <CLLocationManagerDelegate>

/**
 *  Initializes a new location manager with a given
 *  `CLLocationManager`.
 *
 *  @param locationManager A `CLLocationManager` to track
 *                         user's location.
 *
 *  @return An instance of a class that implements `MMLocationManagerDelegate`.
 */
- (id)initWithLocationManager:(CLLocationManager *)locationManager;

/**
 *  Returns that user's last known location.
 *
 *  @return A `CLLocation` object containing
 *          the user's last known location.
 */
- (RACSignal *)getLatestLocation;

@end
