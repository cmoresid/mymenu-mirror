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
#import <RBStoryboardLink/RBStoryboardLinkSource.h>

@class MMSpecialsTypeController;
@class MMSpecialsWeekController;

/**
 *  Displays the specials
 */
@interface MMSpecialsCollectionViewController : UICollectionViewController <MMDBFetcherDelegate,UIToolbarDelegate,UIPopoverControllerDelegate,UISearchBarDelegate, RBStoryboardLinkSource>

/**
 *  The types we can show (Food, Dessert, Drinks specials)
 */
@property(atomic) NSMutableArray * showTypes;

/**
 *  Date the user has selected to show a week of
 */
@property(atomic) NSDate * selectedDate;

/**
 *  Headers for the collection view (Dates)
 */
@property(atomic) NSMutableArray * dateKeys;

/**
 *  All specials by key an date
 */
@property(atomic) NSMutableDictionary * specials;

/**
 *  todays date.
 */
@property(nonatomic,readwrite) NSDate * currentDate;


/**
 *  The types popover view controller, done programmically
 */
@property (nonatomic, strong) UIPopoverController *typesPopoverController;

/**
 *  The week popover view controller, done programmically
 */
@property (nonatomic, strong) UIPopoverController *weekPopoverController;

/**
 *  The view controller that is presented within the types
 *  popover.
 */
@property (nonatomic, strong) MMSpecialsTypeController *typesController;

/**
 *  The view controller that is presented within the week
 *  popover.
 */
@property (nonatomic, strong) MMSpecialsWeekController *weekController;

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

/**
 *  load the a week from the data into the collection view
 *
 *  @param date NSDate to display from
 */
-(void)loadWeek:(NSDate *)date;

@end
