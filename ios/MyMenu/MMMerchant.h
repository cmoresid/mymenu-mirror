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

#import <Foundation/Foundation.h>

/**
* This class represents a merchant or restaurant for a menu item, for the table http://mymenuapp.ca/rest/merchusers
*/
@interface MMMerchant : NSObject

@property(nonatomic) NSNumber *mid;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *password;
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *lastName;
@property(nonatomic) NSString *phone;
@property(nonatomic) NSString *businessname;
@property(nonatomic) NSString *businessnumber;
@property(nonatomic) NSString *desc;
@property(nonatomic) NSString *picture;
@property(nonatomic) NSString *address;
@property(nonatomic) NSString *city;
@property(nonatomic) NSString *locality; //province
@property(nonatomic) NSString *postalcode;
@property(nonatomic) NSString *country;
@property(nonatomic) NSNumber *lat;
@property(nonatomic) NSNumber *longa;
@property(nonatomic) NSString *facebook;
@property(nonatomic) NSString *twitter;
@property(nonatomic) NSString *website;
@property(nonatomic) NSNumber *rating;
@property(nonatomic) NSNumber *ratingcount;
@property(nonatomic) NSString *category;
@property(nonatomic) NSNumber *pricelow;
@property(nonatomic) NSNumber *pricehigh;
@property(nonatomic) NSNumber *opentime;
@property(nonatomic) NSNumber *closetime;
@property(nonatomic) NSNumber *distfromuser;

@end
