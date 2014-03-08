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
 *  Controller for showing the types of specials in a popover on the specials page
 */
@interface MMSpecialsTypeController : UITableViewController

/**
 *  The types of specials
 */
@property(nonatomic,readwrite) NSArray * specialItems;

/**
 *  The controller we are in (Always MMSpecialsCollectionViewController)
 */
@property(nonatomic,readwrite) MMSpecialsCollectionViewController * specialsCollectionController;

@end
