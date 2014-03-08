//
//  MMAboutViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import <UIKit/UIKit.h>

/**
 *  The controller loads the about page from the MyMenu Website
 */
@interface MMAboutViewController : UIViewController <UIWebViewDelegate>


/**
 *  Current Web View on the screen
 */
@property (nonatomic, weak) IBOutlet UIWebView *aboutWebView;

@end
