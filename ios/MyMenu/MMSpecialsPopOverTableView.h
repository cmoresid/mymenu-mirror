//
//  MMSpecialsPopOverTableView.h
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-02-26.
//
//

#import <UIKit/UIKit.h>
#import "MMSpecialsCollectionViewController.h"

@interface MMSpecialsPopOverTableView : UITableViewController

@property(nonatomic,readwrite) NSArray * specialItems;
@property(nonatomic,readwrite) MMSpecialsCollectionViewController * specialsCollectionController;

@end
