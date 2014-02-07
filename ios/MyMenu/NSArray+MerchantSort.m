//
//  NSArray+MerchantSort.m
//  MyMenu
//
//  Created by Chris Moulds on 2/7/2014.
//
//

#import "NSArray+MerchantSort.h"
#import "MMMerchant.h"

@implementation NSArray (MerchantSort)

- (NSArray*)sortMerchant {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = ((MMMerchant*) obj1).distfromuser;
        NSNumber *second = ((MMMerchant*) obj2).distfromuser;
        
        return [first compare:second] == NSOrderedDescending;
    }];
}

@end
