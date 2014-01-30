//
//  MMUser.h
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMUser : NSObject

@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *lastName;
@property(nonatomic, readonly) NSNumber *uid;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *password;
@property(nonatomic) NSString *city;
@property(nonatomic) NSString *locality; //Province
@property(nonatomic) NSString *country;
@property(nonatomic) char gender;
@property(nonatomic) NSString *birthday;
@property(nonatomic) NSString *birthmonth;
@property(nonatomic) NSString *birthyear;
@property(nonatomic) NSString *confirm;


@end
