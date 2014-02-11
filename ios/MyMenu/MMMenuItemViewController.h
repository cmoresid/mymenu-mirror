//
//  MMMenuItemViewController.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-10.
//
//

#import <UIKit/UIKit.h>
#import "MMDBFetcherDelegate.h"
@class MMMerchant;

@interface MMMenuItemViewController : UICollectionViewController <MMDBFetcherDelegate, UICollectionViewDataSource>

@property MMMerchant *selectedRestaurant;
@end
