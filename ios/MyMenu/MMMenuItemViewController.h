//
//  MMMenuItemViewController.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-11.
//
//

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"

@interface MMMenuItemViewController : UIViewController <UITableViewDataSource, MMDBFetcherDelegate>

@property MMMenuItem *touchedItem;
@property MMMerchant *selectedRestaurant;

@property(nonatomic, weak) IBOutlet UILabel * itemName;
@property(nonatomic, weak) IBOutlet UILabel * itemMod;
@property(nonatomic, weak) IBOutlet UILabel * itemRating;
@property(nonatomic, weak) IBOutlet UITextView * itemDescription;
@property(nonatomic, weak) IBOutlet UIImageView * itemImage;
@property(nonatomic, weak) IBOutlet UIView *itemView;
@property(nonatomic, weak) IBOutlet UITableView * tableView;

- (IBAction)shareViaFacebook:(id)sender;
- (IBAction)shareViaTwitter:(id)sender;

@end
