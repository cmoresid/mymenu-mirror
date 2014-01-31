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
* This class represents a special, for the table http://mymenuapp.ca/rest/specials
*/
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
