//
//  MMMenuItemCell.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-08.
//
//

#import "MMMenuItemCell.h"

@implementation MMMenuItemCell
@synthesize titleLabel = _titleLabel;
@synthesize ratinglabel = _ratinglabel;
@synthesize menuImageView = _menuImageView;
@synthesize ratingBg = _ratingBg;
@synthesize priceLabel = _priceLabel;
@synthesize restrictionLabel = _restrictionLabel;
@synthesize descriptionLabel = _descriptionLabel;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
