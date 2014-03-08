//
//  MMAboutViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 3/6/2014.
//
//

#import "MMAboutViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMAboutViewController ()

@end

@implementation MMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  Shows the loading widget
 *
 *  @param webView current web view on screen
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 *  Closes the loading widget
 *
 *  @param webView current web view on the screen
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.aboutWebView.delegate = self;
    [self.aboutWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.mymenuapp.ca/about"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
