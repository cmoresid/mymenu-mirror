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

#import <Social/Social.h>
#import "MMSocialMediaService.h"
#import "MMMenuItem.h"

@implementation MMSocialMediaService

+ (UIViewController *)shareMenuItem:(MMMenuItem *)menuItem {
    NSString *initialMessage = @"I just tried %@! You should try it to! http://www.mymenuapp.ca";
    NSString *postText = [NSString stringWithFormat:initialMessage, menuItem.name];
    UIImage *postImage = [MMSocialMediaService getImageForMenuItem:menuItem];
    
    return [[UIActivityViewController alloc] initWithActivityItems:@[postText, postImage]applicationActivities:nil];
}

+ (UIImage *)getImageForMenuItem:(MMMenuItem *)menuItem {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:menuItem.picture]]];
}

@end
