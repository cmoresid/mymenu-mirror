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

#import "MMMapPopOverViewController.h"
#import "MMRestaurantViewController.h"
#import "UIStoryboard+UIStoryboard_MyMenu.h"

@interface MMMapPopOverViewController ()

@end

@implementation MMMapPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  Called when user touches in the popover to go to the restaurant page.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if (CGRectContainsPoint([self.contentView frame], [touch locationInView:self.contentView])) {
        MMRestaurantViewController *restaurantViewController = [[UIStoryboard menuStoryboard] instantiateViewControllerWithIdentifier:@"restaurantView"];
        restaurantViewController.currentMerchantId = self.merchant.mid;
        
        [self.popOverController dismissPopoverAnimated:YES];
        [self.splitViewNavigationController pushViewController:restaurantViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
