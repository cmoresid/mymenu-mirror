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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userloc = userLocation;

    
#if TARGET_IPHONE_SIMULATOR    
    self.userloc.coordinate = CLLocationCoordinate2DMake(53.53333, -113.5000);
#endif
    
    CLLocationCoordinate2D coords = self.userloc.coordinate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRetrievedUserLocation
                                                        object:self.userloc];
    
    self.configBlock(mapView, self.userloc);
}


@end
