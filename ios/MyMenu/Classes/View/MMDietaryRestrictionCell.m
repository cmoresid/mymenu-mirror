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

#import "MMDietaryRestrictionCell.h"
#import "UIImage+MMTransform.h"
#import <QuartzCore/CAGradientLayer.h>

const CGFloat PADDING_TOP = 2.0f;
const CGFloat PADDING_RIGHT = 3.0f;

@interface MMDietaryRestrictionCell ()

@end

@implementation MMDietaryRestrictionCell

- (CAGradientLayer *)getGradientLayer {
    CGSize contentViewSize = self.contentView.bounds.size;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0.0, 0.0, contentViewSize.width, contentViewSize.height * 0.20);
    gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.40].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.10].CGColor];
    
    gradientLayer.startPoint = CGPointMake(0.0, 0.0f);
    gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    
    return gradientLayer;
}

- (CALayer *)getRestrictionImageMask {
    CGSize contentViewSize = self.contentView.bounds.size;
    UIImage *backgroundImage = [UIImage imageNamed:@"restriction-overlay.png"];
    CGSize imageSize = backgroundImage.size;
    CALayer *aLayer = [CALayer layer];
    
    CGRect  startFrame = CGRectMake(contentViewSize.width - imageSize.width - PADDING_RIGHT, PADDING_TOP, imageSize.width, imageSize.height);
    aLayer.contents = (id)backgroundImage.CGImage;
    aLayer.frame = startFrame;
    
    return aLayer;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        CAGradientLayer *gradientLayer = [self getGradientLayer];
        CALayer *imageLayer = [self getRestrictionImageMask];
        
        [self.restrictionImageView.layer addSublayer:gradientLayer];
        [self.restrictionImageView.layer addSublayer:imageLayer];
        [self.restrictionImageView.layer setValue:gradientLayer forKey:@"GradientLayer"];
        [self.restrictionImageView.layer setValue:imageLayer forKey:@"MaskLayer"];
    }
    else {
        CALayer *gradientLayer = [self.restrictionImageView.layer valueForKey:@"GradientLayer"];
        CALayer *imageLayer = [self.restrictionImageView.layer valueForKey:@"MaskLayer"];
        
        [gradientLayer removeFromSuperlayer];
        [imageLayer removeFromSuperlayer];
        [self.restrictionImageView.layer setValue:nil forKey:@"GradientLayer"];
        [self.restrictionImageView.layer setValue:nil forKey:@"MaskLayer"];
    }
    
    _isSelected = isSelected;
}

@end
