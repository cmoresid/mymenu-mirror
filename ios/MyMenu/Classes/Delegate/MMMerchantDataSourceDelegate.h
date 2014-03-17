//
//  MMMerchantDataSourceDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 3/17/2014.
//
//

#import <Foundation/Foundation.h>

@protocol MMMerchantDataSourceDelegate <NSObject>

- (void)didReceiveMerchants:(NSMutableArray *)merchants;

@end
