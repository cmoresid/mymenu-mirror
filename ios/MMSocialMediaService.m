//
//  MMSocialMediaService.m
//  MyMenu
//
//  Created by Connor Moreside on 2/8/2014.
//
//

#import <Social/Social.h>
#import "MMSocialMediaService.h"
#import "MMMenuItem.h"

@implementation MMSocialMediaService

+ (SLComposeViewController*)shareMenuItem:(MMMenuItem*)menuItem withService:(NSString*)serviceType {
    // Only support Facebook and Twitter for now.
    if ([serviceType isEqualToString:SLServiceTypeFacebook])
        return [self shareMenuItemOnFacebook:menuItem];
    
    if ([serviceType isEqualToString:SLServiceTypeTwitter])
        return [self shareMenuItemOnTwitter:menuItem];
    
    return nil;
}

+ (SLComposeViewController*)shareMenuItemOnFacebook:(MMMenuItem*)menuItem {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        return nil;
    
    SLComposeViewController *fbComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    NSString *initialMessage = @"I just tried %@! You should try it to!";

    [fbComposer setInitialText:[NSString stringWithFormat:initialMessage, menuItem.name]];
    [fbComposer addImage:[self getImageForMenuItem:menuItem]];
    
    return fbComposer;
}

+ (SLComposeViewController*)shareMenuItemOnTwitter:(MMMenuItem*)menuItem {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        return nil;
    
    SLComposeViewController *twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *initialMessage = @"I just tried %@! You should try it to!";
    
    [twitterComposer setInitialText:[NSString stringWithFormat:initialMessage, menuItem.name]];
    [twitterComposer addImage:[self getImageForMenuItem:menuItem]];
    
    return twitterComposer;
}

+ (UIImage*)getImageForMenuItem:(MMMenuItem*)menuItem {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:menuItem.picture]]];
}

@end
