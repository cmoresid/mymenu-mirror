//
//  MMSocialMediaService.h
//  MyMenu
//
//  Created by Connor Moreside on 2/8/2014.
//
//

#import <Foundation/Foundation.h>

extern NSString *const SLServiceTypeFacebook;
extern NSString *const SLServiceTypeTwitter;

@class SLComposeViewController;
@class MMMenuItem;

@interface MMSocialMediaService : NSObject

+ (SLComposeViewController*)shareMenuItem:(MMMenuItem*)menuItem withService:(NSString*)serviceType;

@end
