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
 * A custom cell that dietary restriction. There is a
 * a corresponding dynamic prototype in the storyboard
 * where the actual UI is defined.
 */
@interface MMDietaryRestrictionCell : UICollectionViewCell

/**
 * The label that describes the restriction.
 */
@property(nonatomic, weak) IBOutlet UILabel *restrictionName;

@property(nonatomic, weak) IBOutlet UIImageView *restrictionImageView;

@property(nonatomic, strong) NSNumber *correspondingRestrictionId;

@property(nonatomic) BOOL isSelected;

@end
