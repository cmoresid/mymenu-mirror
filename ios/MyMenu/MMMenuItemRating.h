//
//  MMMenuItemRating.h
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMenuItemRating : NSObject

@property (nonatomic, readonly) NSNumber *id;
@property (nonatomic) NSString *useremail;
@property (nonatomic) NSNumber *menuid;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *merchid;
@property (nonatomic) NSString *review;


@end
