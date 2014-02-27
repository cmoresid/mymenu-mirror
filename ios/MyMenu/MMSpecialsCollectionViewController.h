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

#import <UIKit/UIKit.h>
#import "MMDBFetcherDelegate.h"

@interface MMSpecialsCollectionViewController : UICollectionViewController <MMDBFetcherDelegate>

@property(nonatomic) NSMutableArray * showTypes;
@property(nonatomic) NSMutableArray * dateIndex;
@property(atomic) NSMutableArray * specials;
@property(nonatomic,readwrite) NSDate * currentDate;

/**
 * Adds a Special type to show, and reloads the view as Needed.
 */
-(void)addShowType:(NSString *)type;

/**
 * Removes a Special type to show, and reloads the view as Needed.
 */
-(void)removeShowType:(NSString *)type;

/**
 * Checks if a Type is "Currently" being displayed.
 */
-(bool)containsShowType:(NSString *)type;

@end
