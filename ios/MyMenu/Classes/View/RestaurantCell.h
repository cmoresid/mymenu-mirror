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

/**
 *  A custom table view cell that represents
 *  a restaurant. This is used in `MMMasterRestaurantTableViewController`. 
 *  The UI layout resides in an external XIB file, namely
 *  `Resources/XIB/RestaurantTableCell.xib`
 */
@interface RestaurantCell : UITableViewCell

/**
 *  The label that contains the name of the restaurant.
 */
@property(nonatomic, weak) IBOutlet UILabel *restaurantNameLabel;

/**
 *  The label that contains the category of the restaurant.
 */
@property(nonatomic, weak) IBOutlet UILabel *categoryLabel;

/**
 *  The label that contains the rating of the restaurant.
 */
@property(nonatomic, weak) IBOutlet UILabel *ratinglabel;

/**
 *  The label that contains the distance from the
 *  user's location and the restaurant's location.
 */
@property(nonatomic, weak) IBOutlet UILabel *distanceLabel;

/**
 *  The label that contains the address of the restaurant.
 */
@property(nonatomic, weak) IBOutlet UILabel *addressLabel;

/**
 *  The view that the rating label resides in. The background
 *  color for this view is set to a light grey color.
 */
@property(nonatomic, weak) IBOutlet UIView *ratingBg;

/**
 *  The image view that contains a small thumbnail image 
 *  of the restaurant.
 */
@property(nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
