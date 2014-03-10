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

#import <UIKit/UIKit.h>

/**
 *  A child controller of the `MMMasterProfileViewController`. Provides
 *  a web view that displays the About page on the MyMenu website.
 */
@interface MMAboutViewController : UIViewController <UIWebViewDelegate>

/**
 *  The web view that displays the About page.
 */
@property (nonatomic, weak) IBOutlet UIWebView *aboutWebView;

@end
