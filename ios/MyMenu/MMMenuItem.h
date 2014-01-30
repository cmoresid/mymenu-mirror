//
//  MMMenuItem.h
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

/* This is a menu item that corresponds to a specific restauraunt.*/

#import <Foundation/Foundation.h>

@interface MMMenuItem : NSObject

@property(nonatomic, readonly) NSNumber *itemid;
@property(nonatomic, readonly) NSNumber *merchid;
@property(nonatomic) NSString *name;
@property(nonatomic) NSNumber *cost;
@property(nonatomic) NSString *picture;
@property(nonatomic) NSString *desc;
@property(nonatomic) NSString *mods;
@property(nonatomic) NSNumber *rating;
@property(nonatomic) NSNumber *ratingcount;
@property(nonatomic) NSNumber *categoryid;


@end
