//
//  UIStoryboard+UIStoryboard_MyMenu.m
//  MyMenu
//
//  Created by Connor Moreside on 3/7/2014.
//
//

#import "UIStoryboard+UIStoryboard_MyMenu.h"

@implementation UIStoryboard (UIStoryboard_MyMenu)

+ (UIStoryboard*)mainStoryBoard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard*)restaurantSpecialsStoryboard {
    return [UIStoryboard storyboardWithName:@"Specials" bundle:nil];
}

@end
