//
//  MMSpecial.h
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSpecial : NSObject

@property(nonatomic, readonly) NSNumber *id;
@property(nonatomic) NSNumber *merchid;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *merchant;
@property(nonatomic) NSString *desc;
@property(nonatomic) NSNumber *categoryid;
@property(nonatomic) NSString *picture;
@property(nonatomic) NSNumber *occurtype;
@property(nonatomic) NSString *weekday;
@property(nonatomic) NSDate *startdate;
@property(nonatomic) NSDate *enddate;
@property(nonatomic) char yearly;

@end
