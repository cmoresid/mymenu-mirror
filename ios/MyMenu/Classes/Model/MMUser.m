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

#import "MMUser.h"

@implementation MMUser

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self != nil) {
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.locality = [decoder decodeObjectForKey:@"locality"];
        self.country = [decoder decodeObjectForKey:@"country"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.locality forKey:@"locality"];
    [aCoder encodeObject:self.country forKey:@"country"];
}

- (NSString *)userAddress {
    return [NSString stringWithFormat:@"%@, %@, %@", self.city, self.locality, @"Canada"];
}

@end
