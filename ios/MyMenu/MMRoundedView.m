//
//  MMRoundedView.m
//  MyMenu
//
//  Created by ninjavmware on 2014-01-27.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMRoundedView.h"

@implementation MMRoundedView

- (id)initWithFrame:(CGRect)frame {
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
