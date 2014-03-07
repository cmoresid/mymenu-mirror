//
//  MMMapDelegate.m
//  MyMenu
//
//  Created by Chris Moulds on 2/6/2014.
//
//

#import "MMLocationManager.h"

NSString *const kRetrievedUserLocation = @"RetrievedUserLocation";

@implementation MMLocationManager

- (id)initWithConfigurationBlock:(ConfigureMapView)conf {
    self = [super init];

    if (self != nil) {
        self.configBlock = conf;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }

    return self;
}

- (void)startTrackingUserLocation {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopTrackingUserLocation {
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.configBlock(manager, locations);
}

@end
