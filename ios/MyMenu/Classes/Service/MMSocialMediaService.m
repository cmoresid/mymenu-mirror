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

+ (SLComposeViewController *)shareMenuItem:(MMMenuItem *)menuItem withService:(NSString *)serviceType {
    // Only support Facebook and Twitter for now.
    if ([serviceType isEqualToString:SLServiceTypeFacebook])
        return [self shareMenuItemOnFacebook:menuItem];

    if ([serviceType isEqualToString:SLServiceTypeTwitter])
        return [self shareMenuItemOnTwitter:menuItem];

    return nil;
}

+ (SLComposeViewController *)shareMenuItemOnFacebook:(MMMenuItem *)menuItem {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        return nil;

    SLComposeViewController *fbComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

    NSString *initialMessage = @"I just tried %@! You should try it to! http://www.mymenuapp.ca";

    [fbComposer setInitialText:[NSString stringWithFormat:initialMessage, menuItem.name]];
    [fbComposer addImage:[self getImageForMenuItem:menuItem]];

    return fbComposer;
}

+ (SLComposeViewController *)shareMenuItemOnTwitter:(MMMenuItem *)menuItem {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        return nil;

    SLComposeViewController *twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

    NSString *initialMessage = @"I just tried %@! You should try it to! http://www.mymenuapp.ca";

    [twitterComposer setInitialText:[NSString stringWithFormat:initialMessage, menuItem.name]];
    [twitterComposer addImage:[self getImageForMenuItem:menuItem]];

    return twitterComposer;
}

+ (UIImage *)getImageForMenuItem:(MMMenuItem *)menuItem {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:menuItem.picture]]];
}

@end
