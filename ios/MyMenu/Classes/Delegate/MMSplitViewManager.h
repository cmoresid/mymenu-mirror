//
//  MMSplitViewDelegate.h
//  MyMenu
//
//  Created by Connor Moreside on 2014-03-25.
//
//

#import <Foundation/Foundation.h>

@protocol MMDetailViewController

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;

@end

@interface MMSplitViewManager : NSObject <UISplitViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, weak) IBOutlet UIViewController<MMDetailViewController> *detailViewController;

@end
