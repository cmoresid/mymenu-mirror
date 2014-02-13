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

@interface MMMenuItemViewController : UIViewController

@property MMMenuItem *touchedItem;
@property MMMerchant *selectedRestaurant;

@property(nonatomic, weak) IBOutlet UILabel * itemName;
@property(nonatomic, weak) IBOutlet UILabel * itemNumber;
@property(nonatomic, weak) IBOutlet UILabel * itemRating;
@property(nonatomic, weak) IBOutlet UITextView * itemDescription;
@property(nonatomic, weak) IBOutlet UIImageView * itemImage;
@property(nonatomic, weak) IBOutlet UIView *itemView;

- (IBAction)shareViaFacebook:(id)sender;
- (IBAction)shareViaTwitter:(id)sender;

@end
