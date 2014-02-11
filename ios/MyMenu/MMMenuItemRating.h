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
* This class represents a review for a menu item, for the table http://mymenuapp.ca/rest/ratings
*/
@interface MMMenuItemRating : NSObject

@property(nonatomic) NSNumber *id;
@property(nonatomic) NSString *useremail;
@property(nonatomic) NSNumber *menuid;
@property(nonatomic) NSNumber *rating;
@property(nonatomic) NSNumber *merchid;
@property(nonatomic) NSString *review;
@property(nonatomic) NSDate *date;

@end
