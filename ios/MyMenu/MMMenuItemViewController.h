//
//  MMMenuItemViewController.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-11.
//
//

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"

@interface MMMenuItemViewController : UIViewController

@property MMMenuItem *touchedItem;
@property(nonatomic, weak) IBOutlet UILabel *itemName;

@end
