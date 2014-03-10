//
//  MMStaticDataHelper.m
//  MyMenu
//
//  Created by Connor Moreside on 3/9/2014.
//
//

#import "MMStaticDataHelper.h"

@interface MMStaticDataHelper () {
    NSDictionary *_data;
}

- (id)init;

@end

@implementation MMStaticDataHelper

static MMStaticDataHelper *instance;

- (id)init {
    self = [super init];

    if (self) {
        NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"StaticData"
                                                                 ofType:@"plist"];

        _data = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    }

    return self;
}

+ (MMStaticDataHelper *)sharedDataHelper {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }

    return instance;
}

- (NSString *)getAboutURL {
    return [_data objectForKey:@"AboutURL"];
}

@end
