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

#import "MMRatingView.h"
#include <math.h>

@interface MMRatingView()

- (CGFloat)degreesToRadians:(CGFloat)radians;

@end

@implementation MMRatingView

- (CGFloat)degreesToRadians:(CGFloat)radians {
    return radians * 0.0174532925199432958f;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setWheelPercentage:(CGFloat)wheelPercentage {
    _wheelPercentage = fmaxf(0.0f, fminf(1.0f, wheelPercentage));
    _rating = [NSNumber numberWithInteger:((NSInteger)round(_wheelPercentage * 10))];
    
    [self setNeedsDisplay];
}

- (void)setWheelFillColor:(UIColor *)wheelFillColor {
    _wheelFillColor = wheelFillColor;
    
    [self setNeedsDisplay];
}

- (void)setWheelBackgroundColor:(UIColor *)wheelBackgroundColor {
    _wheelBackgroundColor = wheelBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_wheelBackgroundColor) {
		[_wheelBackgroundColor set];
		CGContextFillEllipseInRect(context, rect);
	}
    
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGFloat radius = center.y;
	CGFloat angle = [self degreesToRadians:(360.0f * self.wheelPercentage) + -90.0f];
	CGPoint points[3] = {
		CGPointMake(center.x, 0.0f),
		center,
		CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))
	};
    
	if (self.wheelFillColor) {
		[self.wheelFillColor set];
		if (self.wheelPercentage > 0.0f) {
			CGContextAddLines(context, points, sizeof(points) / sizeof(points[0]));
			CGContextAddArc(context, center.x, center.y, radius, [self degreesToRadians:-90.0], angle, false);
			CGContextDrawPath(context, kCGPathEOFill);
		}
	}
    
    // Create 'doughnut' appearence
    CGRect doughnut = CGRectMake(center.x - 75.0f, center.y - 75.0f, 150.0f, 150.0f);
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillEllipseInRect(context, doughnut);
    
    // Draw text value
    UIFont* font = [UIFont fontWithName:@"Arial" size:110];
    UIColor* textColor = [UIColor grayColor];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor, NSParagraphStyleAttributeName: paragraphStyle  };
    
    CGRect textRect;
    textRect.size = CGSizeMake(125.0f, 110.0f);
    textRect.origin = CGPointMake(CGRectGetMidX(doughnut) - textRect.size.width / 2.0f, CGRectGetMidY(doughnut) - textRect.size.height / 2.0);
    
    NSString *ratingTextValue = [NSString stringWithFormat:@"%@", self.rating];
    [ratingTextValue drawInRect:textRect withAttributes:stringAttrs];
}

@end
