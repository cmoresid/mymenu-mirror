//
//  Copyright (C) 2014  MyMenu, Inc.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see [http://www.gnu.org/licenses/].
//

#import "MMAboutViewController.h"
#import "MMStaticDataHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MMAboutViewController ()

@end

@implementation MMAboutViewController

#pragma mark - View Controller Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"About", nil);
    
    if (self.navigationPaneBarButtonItem) {
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem
                                         animated:NO];
    }
    
    self.aboutWebView.delegate = self;
    [self.aboutWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[MMStaticDataHelper sharedDataHelper] getAboutURL]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem {
    if (navigationPaneBarButtonItem == _navigationPaneBarButtonItem)
        return;
    
    if (navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
    else
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
}

#pragma mark - Webview Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
