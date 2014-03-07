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
 * A pie chart-like view that allows a user
 * to select a number between 1-10 inclusive.
 */
@interface MMRatingView : UIView

/**
 The current percentage of the wheel that is filled in.
 
 The current percentage is represented by a floating-point value between `0.1` and `1.0`, inclusive, where `1.0` indicates a value of 10 and a value of `0.1` indicates a value of 1. Values less than `0.1` and greater than `1.0` are bounded to those respective values.
 */
@property(nonatomic, assign)   CGFloat  wheelPercentage;

/**
 * An integer representation of the current wheel percentage. Automatically updated
 * when the `wheelPercentage` property is updated.
 */
@property(nonatomic, readonly) NSNumber *rating;

/**
 * The color of the fill color.
 */
@property(nonatomic, strong)   UIColor  *wheelFillColor;

/**
 * The background color of the wheel.
 */
@property(nonatomic, strong)   UIColor  *wheelBackgroundColor;

@end
