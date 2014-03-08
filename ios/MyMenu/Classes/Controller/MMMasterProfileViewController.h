//
//  MMMasterProfileViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 3/5/2014.
//
//

#import <UIKit/UIKit.h>
#import "MMAccountViewController.h"
#import "MMBaseNavigationController.h"

/**
 *  Master controller that encapsulates the Profile Tab
 */
@interface MMMasterProfileViewController : UITableViewController

/**
 *  Account View Controller
 */
@property (nonatomic, strong) MMBaseNavigationController *accountController;

/**
 *  Reviews View Controller
 */
@property (nonatomic, strong) MMBaseNavigationController *reviewsController;

/**
 *  About View Controller
 */
@property (nonatomic, strong) MMBaseNavigationController *aboutController;

/**
 *  Notifications View Controller
 *  Not implemented yet.
 */
@property (nonatomic, strong) MMBaseNavigationController *notificationsController;

/**
 *  The current selected view controller.
 */
@property (nonatomic, strong) MMBaseNavigationController *currentDetailViewController;

@end
