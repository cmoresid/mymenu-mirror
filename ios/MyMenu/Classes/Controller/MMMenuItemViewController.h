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
