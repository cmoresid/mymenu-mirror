//
//  MMUser.m
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMUser.h"

@implementation MMUser


- (id)init {
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self != nil){
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.city= [decoder decodeObjectForKey:@"city"];
        self.locality = [decoder decodeObjectForKey:@"locality"];
        self.country = [decoder decodeObjectForKey:@"country"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.locality forKey:@"locality"];
    [aCoder encodeObject:self.country forKey:@"country"];
    
}


@end
