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

#import "MMLocationManager.h"
#import "MMLoginManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const kMMLocationManagerDelegateErrorDomain = @"ca.mymenu.MMLocationManagerDelegate.ErrorDomain";
const NSInteger ERR_MM_LMD_NO_MOST_RECENT_LOCATION = -1;
const NSInteger ERR_MM_LMD_LOCATION_SERVICES_DENIED = -2;

@interface MMLocationManager ()

@property(readwrite, strong, nonatomic) CLLocation *defaultLocation;
@property(strong, nonatomic) RACSubject *locationSubject;
@property(strong, nonatomic) CLLocationManager *locManager;

@end

@implementation MMLocationManager

#pragma mark - Initializers

- (instancetype)init {
    CLLocationManager *defaultLocationManager = [[CLLocationManager alloc] init];
    defaultLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    return [self initWithLocationManager:defaultLocationManager];
}

- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager {
    if (self = [super init]) {
        self.locManager = locationManager;
        [self.locManager setDelegate:self];
        self.locationSubject = [RACReplaySubject subject];
    }
    
    return self;
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations");
    [manager stopMonitoringSignificantLocationChanges];
    [self updateLocationSubject];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status");
    if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"... and authorized so about to start monitoring");
        [manager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error");
    if ([error domain] == kCLErrorDomain) {
        if ([error code] == kCLErrorDenied) {
            [manager stopUpdatingLocation];
            [self getUsersDefaultLocation];
            return;
        }
        NSLog(@"about to sendError to Location Subject");
        [self.locationSubject sendError:[self locationServicesDeniedError]];
    }
}

#pragma mark - MMLocationManager Delegate Methods

- (RACSignal *)getLatestLocation {
    // A RACSubject is a RACSignal, so we can change the return type here.
    NSLog(@"latestLocationSignal");
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Services NOT enabled, to trying to handle that");
        [self handleRequestForLocationWhenServicesNotEnabled];
    }
    else {
        NSLog(@"Services Enabled, to trying to handle that");
        [self handleRequestForLocationWhenServicesEnabled];
    }
    
    return self.locationSubject;
}

#pragma mark - Private Helper Methods

- (void)handleRequestForLocationWhenServicesNotEnabled {
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus != kCLAuthorizationStatusRestricted && authStatus != kCLAuthorizationStatusDenied) {
        NSLog(@"handleRequestForLocationWhenServicesNotEnabled -- Starting to monitor on %@", self.locManager);
        [self.locManager startMonitoringSignificantLocationChanges];
    }
    else {
        NSLog(@"handleRequestForLocationWhenServicesNotEnabled -- Try to get user's default location.");
        [self getUsersDefaultLocation];
    }
}

- (void)handleRequestForLocationWhenServicesEnabled {
    if ([self locationRefreshRequired]) {
        NSLog(@"handleRequestForLocationWhenServicesEnabled -- Starting to monitor on %@", self.locManager);
        [self.locManager startMonitoringSignificantLocationChanges];
    }
    else {
        NSLog(@"handleRequestForLocationWhenServicesEnabled -- Going to try to update Location subject");
        [self updateLocationSubject];
    }
}

- (void)getUsersDefaultLocation {
    NSLog(@"getUsersDefaultLocation -- Getting user's location from CLGeocoder");
    
    if ([[MMLoginManager sharedLoginManager] isUserLoggedInAsGuest]) {
        [self.locationSubject sendError:[self locationServicesDeniedError]];
        return;
    }

    MMUser *userProfile = [[MMLoginManager sharedLoginManager] getLoggedInUser];
    
    CLGeocoder *geoEncoder = [[CLGeocoder alloc] init];
    [geoEncoder geocodeAddressString:[userProfile userAddress] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) {
            [self.locationSubject sendError:[self locationServicesDeniedError]];
            return;
        }
        
        CLPlacemark *locationPlacemark = [placemarks firstObject];
        [self.locationSubject sendNext:locationPlacemark.location];
    }];
}

- (void)updateLocationSubject {
    CLLocation *newLocation = [self mostRecentLocation];
    if (!newLocation) {
        NSLog(@"updateLocationSubject -- No location, so ERROR");
        [self.locationSubject sendError:[self noMostRecentLocationError]];
    } else {
        NSLog(@"updateLocationSubject -- About to sendNext location");
        [self.locationSubject sendNext:newLocation];
    }
}

- (int)sixHoursAgo {
    //6 hours in seconds
    return 21600;
}

- (CLLocation *)mostRecentLocation {
    NSLog(@"mostRecentLocation on %@", self.locManager);
    return [self.locManager location];
}

- (BOOL)locationRefreshRequired {
    CLLocation *location = [self mostRecentLocation];
    
    return (location == nil) ||
        (fabs([location.timestamp timeIntervalSinceNow]) > [self sixHoursAgo]);
}

#pragma mark - Error Creation methods

- (NSError *)noMostRecentLocationError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey : NSLocalizedString(@"No most recent location.", nil),
                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Most recent location was set to nil value, which is unexpected", nil),
                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Contact support.", nil)
                               };
    NSError *error = [NSError errorWithDomain:kMMLocationManagerDelegateErrorDomain
                                         code:ERR_MM_LMD_NO_MOST_RECENT_LOCATION
                                     userInfo:userInfo];
    return error;
}

- (NSError *)locationServicesDeniedError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey : NSLocalizedString(@"Unable to get location.", nil),
                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Location Services Denied or Restricted", nil),
                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Contact support.", nil)
                               };
    NSError *error = [NSError errorWithDomain:kMMLocationManagerDelegateErrorDomain
                                         code:ERR_MM_LMD_LOCATION_SERVICES_DENIED
                                     userInfo:userInfo];
    return error;
}


@end
