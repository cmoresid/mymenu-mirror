//
//  MMMapDelegate.h.h
//  MyMenu
//
//  Created by Chris Moulds on 2/6/2014.
//
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
