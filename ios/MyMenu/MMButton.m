//
//  MMButton.m
//  MyMenu
//
//  Created by Chris Pavlicek on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MMButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}
*/
@end
