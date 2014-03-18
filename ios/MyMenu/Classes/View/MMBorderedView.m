//
//  MMBorderedView.m
//  MyMenu
//
//  Created by Connor Moreside on 3/13/2014.
//
//

#import "MMBorderedView.h"
#import "UIColor+MyMenuColors.h"

@implementation MMBorderedView

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
    self.layer.borderColor = [UIColor lightBackgroundGray].CGColor;
    self.layer.borderWidth = 0.5f;
}

@end
