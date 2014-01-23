//
//  MMMerchant.h
//  MyMenu
//
//  Created by Chris Moulds on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMerchant : NSObject

@property (nonatomic) NSNumber *mid;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *businessname;
@property (nonatomic) NSString *businessnumber;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *picture;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *locality; //province
@property (nonatomic) NSString *postalcode;
@property (nonatomic) NSString *country;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *longa;
@property (nonatomic) NSString *facebook;
@property (nonatomic) NSString *twitter;
@property (nonatomic) NSString *website;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *ratingcount;
@property (nonatomic) NSNumber *categoryid;


@end
