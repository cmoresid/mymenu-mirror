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
* This class represents a dietary restriction, for the table http://mymenuapp.ca/rest/restrictions
*/
@interface MMRestriction : NSObject

@property(nonatomic) NSNumber *id;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(atomic) UIImage *imageRep;

@end
