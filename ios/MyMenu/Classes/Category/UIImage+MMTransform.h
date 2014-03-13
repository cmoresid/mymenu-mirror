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
 *  Adds custom image transformations that are needed
 *  for our application. Mainly a grey scale transformation
 *  and adding a mask to an existing image.
 */
@interface UIImage (MMTransform)

/**
 *  Applies a greyscale filter to the specified
 *  image.
 *
 *  @param image The image to apply the filter to.
 *
 *  @return A new image that has the grey filter applied
 */
+ (UIImage *)addRestrictionMask:(UIImage *)image;

/**
 *  Resizes an image to the specified dimensions.
 *
 *  @param image   The image to be resized.
 *  @param newSize The new dimensions of the image.
 *
 *  @return The image with the new dimensions.
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
