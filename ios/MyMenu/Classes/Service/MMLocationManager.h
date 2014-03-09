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

/**
 *  Call-back block that is called once the user's
 *  current location has been retrieved.
 *
 *  @param The location manager
 *  @param The array of `CGLocation` objects that represents
 *         the current and past user location
 */
typedef void (^ConfigureMapView)(CLLocationManager *, NSArray *);

/**
 *  The identifier that describes the notification that
 *  `MMLocationManager` sends once it receives the
 *  user's location.
 */
extern NSString *const kRetrievedUserLocation;

/**
 *  An object that implements the `CLLocationManagerDelegate`
 *  provided by Apple.
 */
@interface MMLocationManager : NSObject <CLLocationManagerDelegate>

/**
 *  A callback block that is called once the `MMLocationManager`
 *  receives the user's current location.
 */
@property(nonatomic, copy) ConfigureMapView configBlock;

/**
 *  The object that actually retrieves the user's
 *  location.
 */
@property(nonatomic, strong) CLLocationManager *locationManager;

/**
 *  The constructor that receives a block that is called
 *  once the `MMLocationManager` receives the user's current
 *  location.
 *
 *  @param conf The callback block that is called
 *              when the `MMLocationManager` retrieves
 *              the user's current location.
 *
 *  @return An `MMLocationManager` object.
 */
- (id)initWithConfigurationBlock:(ConfigureMapView)conf;

/**
 *  Starts tracking the user's location for
 *  significant changes.
 */
- (void)startTrackingUserLocation;

/**
 *  Stops tracking the user's location.
 */
- (void)stopTrackingUserLocation;

@end
