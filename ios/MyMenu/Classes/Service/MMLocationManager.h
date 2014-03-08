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

typedef void (^ConfigureMapView)(CLLocationManager *, NSArray *);

extern NSString *const kRetrievedUserLocation;

@interface MMLocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, copy) ConfigureMapView configBlock;
@property(nonatomic, strong) CLLocationManager *locationManager;

- (id)initWithConfigurationBlock:(ConfigureMapView)conf;

- (void)startTrackingUserLocation;

- (void)stopTrackingUserLocation;


@end
