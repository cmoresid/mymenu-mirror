//
//  MMSpecialsPopOverTableView.h
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-02-26.
//
//

#import <UIKit/UIKit.h>
#import "MMSpecialsCollectionViewController.h"

/**
 *  Controller for showing the weeks we can show to the user in the specials view
 */
@interface MMSpecialsWeekController : UITableViewController

/**
 *  Weeks from date
 */
@property(nonatomic,readwrite) NSArray * weeks;

/**
 *   The selected week
 */
@property(nonatomic) NSUInteger selectedWeek;

/**
 *  The controller we are in (Always MMSpecialsCollectionViewController)
 */
@property(nonatomic,readwrite) MMSpecialsCollectionViewController * specialsCollectionController;

/**
 *  Required height for the tableview
 *
 *  @return CGSize use in View.
 */
- (CGSize)contentSizeForViewInPopover;

@end
