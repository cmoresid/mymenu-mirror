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

@interface MMMenuItemViewController : UIViewController <UITableViewDataSource, MMDBFetcherDelegate, UITextViewDelegate, UIPopoverControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property MMMenuItem *touchedItem;
@property MMMerchant *selectedRestaurant;
@property (nonatomic, strong) UIPopoverController * popOverController;

@property(nonatomic, weak) IBOutlet UILabel * itemName;
@property(nonatomic, weak) IBOutlet UITextView * reviewField;
@property(nonatomic, weak) IBOutlet UITextView * activeField;
@property(nonatomic, weak) IBOutlet UILabel * itemRating;
@property(nonatomic, weak) IBOutlet UITextView * itemDescription;
@property(nonatomic, weak) IBOutlet UIImageView * itemImage;
@property(nonatomic, weak) IBOutlet UIView *itemView;
@property(nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, weak) IBOutlet UIButton * ratingButton;
@property (nonatomic, weak) IBOutlet UIButton * eatenThisButton;
@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet UINavigationBar * navigationBar;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *reviewSegment;



- (IBAction)shareViaFacebook:(id)sender;
- (IBAction)shareViaTwitter:(id)sender;
- (IBAction)ratingButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)iveEatenThis:(id)sender;

@end
