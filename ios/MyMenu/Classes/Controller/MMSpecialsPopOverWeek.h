//
//  MMSpecialsPopOverTableView.h
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-02-26.
//
//

#import <UIKit/UIKit.h>
#import "MMSpecialsCollectionViewController.h"

@interface MMSpecialsPopOverWeek : UITableViewController

@property(nonatomic,readwrite) NSArray * weeks;
@property(nonatomic) NSUInteger selectedWeek;
@property(nonatomic,readwrite) MMSpecialsCollectionViewController * specialsCollectionController;

- (CGSize)contentSizeForViewInPopover;

@end
