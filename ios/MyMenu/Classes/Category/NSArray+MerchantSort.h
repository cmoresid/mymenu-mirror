//
//  NSArray+MerchantSort.h
//  MyMenu
//
//  Created by Chris Moulds on 2/7/2014.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (MerchantSort)

- (NSArray *)sortMerchantByDistance;
- (NSArray *)sortMerchantByTopRated;
- (NSArray *)sortMerchantByCusine;

@end
