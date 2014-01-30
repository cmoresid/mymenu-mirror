//
//  MMMasterViewController.h
//  Master
//
//  Created by Chris Pavlicek on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMDetailViewController;

@interface MMMasterViewController : UITableViewController

@property(nonatomic, retain) NSArray *restaurants;
@property(strong, nonatomic) MMDetailViewController *detailViewController;

@end
