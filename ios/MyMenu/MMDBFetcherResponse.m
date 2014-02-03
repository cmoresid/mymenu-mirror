//
//  MMDBFetcherResponse.m
//  MyMenu
//
//  Created by Connor Moreside on 2/1/2014.
//
//

#import "MMDBFetcherResponse.h"

@implementation MMDBFetcherResponse

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        self.messages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
