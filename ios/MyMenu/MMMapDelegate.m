//
//  MMMapDelegate.m
//  MyMenu
//
//  Created by Chris Moulds on 2/6/2014.
//
//

#import "MMMapDelegate.h"

NSString* const kRetrievedUserLocation = @"RetrievedUserLocation";

@implementation MMMapDelegate

- (id)initWithConfigurationBlock:(ConfigureMapView)conf {
    self = [super init];
    
    if (self != nil) {
        self.configBlock = conf;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.configBlock(manager, locations);
}

@end
