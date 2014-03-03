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

- (NSArray *)sortMerchantByDistance {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = ((MMMerchant *) obj1).distfromuser;
        NSNumber *second = ((MMMerchant *) obj2).distfromuser;

        return [first compare:second] == NSOrderedDescending;
    }];
}

- (NSArray *)sortMerchantByCusine {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"category"
                                                           ascending:YES
                                                            selector:@selector(caseInsensitiveCompare:)];
    
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

- (NSArray *)sortMerchantByTopRated {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = ((MMMerchant *) obj1).rating;
        NSNumber *second = ((MMMerchant *) obj2).rating;
        
        return [first compare:second] == NSOrderedAscending;
    }];
}

@end
