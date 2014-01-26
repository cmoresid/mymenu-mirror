//
//  RestaurantCell.m
//  MyMenu
//
//  Created by ninjavmware on 2014-01-25.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell

@synthesize nameLabel = _nameLabel;
@synthesize numberLabel = _numberLabel;
@synthesize ratinglabel = _ratinglabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize ratingview = _ratingview;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
