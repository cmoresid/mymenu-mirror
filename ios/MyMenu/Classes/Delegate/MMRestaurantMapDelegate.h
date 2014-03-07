//
//  MMRestaurantMapDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 2/9/2014.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 * Implements the `MMMapViewDelegate` protocol provided by
 * Apple. We implement the delegate in order to provide
 * custom pins for the restaurants.
 */
@interface MMRestaurantMapDelegate : NSObject <MKMapViewDelegate>

@end
