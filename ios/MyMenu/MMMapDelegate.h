//
//  MMMapDelegate.h.h
//  MyMenu
//
//  Created by Chris Moulds on 2/6/2014.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^ConfigureMapView)(MKMapView*, MKUserLocation*);

extern NSString* const kRetrievedUserLocation;

@interface MMMapDelegate : NSObject <MKMapViewDelegate>

@property MKUserLocation *userloc;
@property(nonatomic,copy) ConfigureMapView configBlock;

- (id)initWithConfigurationBlock:(ConfigureMapView)conf;



@end
