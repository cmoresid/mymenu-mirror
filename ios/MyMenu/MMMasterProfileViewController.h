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

@interface MMMasterProfileViewController : UITableViewController

@property (nonatomic, strong) MMBaseNavigationController *accountController;
@property (nonatomic, strong) MMBaseNavigationController *reviewsController;
@property (nonatomic, strong) MMBaseNavigationController *aboutController;
@property (nonatomic, strong) MMBaseNavigationController *notificationsController;

@property (nonatomic, strong) MMBaseNavigationController *currentDetailViewController;

@end
