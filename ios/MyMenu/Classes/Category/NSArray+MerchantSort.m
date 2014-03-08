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
