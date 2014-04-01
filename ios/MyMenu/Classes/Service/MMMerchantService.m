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

#import "MMMerchantService.h"
#import "MMDBFetcher.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreLocation/CoreLocation.h>

@interface MMMerchantService ()

@property(nonatomic, strong) NSCache *cachedServiceCalls;

@end

@implementation MMMerchantService

static MMMerchantService *instance;

+ (instancetype)sharedService {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.cachedServiceCalls = [[NSCache alloc] init];
    }
    
    return self;
}

- (RACSignal *)getMerchantWithMerchantID:(NSNumber *)merchantId {
    NSString *key = [NSString stringWithFormat:@"merchid/%@", [merchantId stringValue]];
    RACSignal *compressedMerchantsSignal = [[MMDBFetcher get] getMerchant:merchantId];
    
    return [self configureOrGetCachedForSignal:compressedMerchantsSignal withKey:key];
}

- (RACSignal *)getDefaultCompressedMerchantsForLocation:(CLLocation *)location {
    NSString *desc = [self coordStringFromLocation:location];
    NSString *key = [NSString stringWithFormat:@"compressed-default/%@", desc];
    RACSignal *compressedMerchantsSignal = [[MMDBFetcher get] getCompressedMerchants:location];
    
    return [self configureOrGetCachedForSignal:compressedMerchantsSignal withKey:key];
}

// Don't cache these calls; this is mainly used
// for searching. Say the user is typing "boston pizza"
// We don't want to cache results for "b", "bo", "bos", etc...
- (RACSignal *)getCompressedMerchantsForLocation:(CLLocation *)location withName:(NSString *)merchantName {
    return [[MMDBFetcher get] getCompressedMerchantsByName:location withName:merchantName];
}

- (RACSignal *)getCompressedMerchantsForLocation:(CLLocation *)location withCuisineType:(NSString *)cuisine {
    NSString *desc = [self coordStringFromLocation:location];
    NSString *key = [NSString stringWithFormat:@"compressed-cuisine/%@/%@", cuisine, desc];
    RACSignal *compressedMerchantsSignal = [[MMDBFetcher get] getCompressedMerchantsByCuisine:location withCuisine:cuisine];
    
    return [self configureOrGetCachedForSignal:compressedMerchantsSignal withKey:key];
}

- (RACSignal *)configureOrGetCachedForSignal:(RACSignal *)signal withKey:(NSString *)key {
    RACMulticastConnection *existingConnection = [self.cachedServiceCalls objectForKey:key];
    
    if (existingConnection) {
        return existingConnection.signal;
    }

    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    [connection connect];
    
    [self.cachedServiceCalls setObject:connection forKey:key];
    
    return connection.signal;
}

- (NSString *)coordStringFromLocation:(CLLocation *)location {
    CLLocationCoordinate2D coords = location.coordinate;
    
    return [NSString stringWithFormat:@"%f/%f",coords.latitude,coords.longitude];
}

@end
