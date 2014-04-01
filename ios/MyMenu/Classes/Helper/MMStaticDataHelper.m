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

#import "MMStaticDataHelper.h"

@interface MMStaticDataHelper () {
    NSDictionary *_data;
}

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

- (NSArray *)getSelectedTabBarImageNames {
    return [_data objectForKey:@"SelectedTabBarImages"];
}

@end
