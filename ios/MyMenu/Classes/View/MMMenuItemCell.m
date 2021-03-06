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

#import "MMMenuItemCell.h"

@implementation MMMenuItemCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.titleView.contentInset = UIEdgeInsetsMake(-12, 0, -5, 0);
    self.titleView.editable = NO;
    self.titleView.scrollEnabled = NO;
    self.titleView.textContainer.lineFragmentPadding = 0;
    self.titleView.textContainer.maximumNumberOfLines = 1;
    self.titleView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleView.userInteractionEnabled = YES;
    self.descriptionView.contentInset = UIEdgeInsetsMake(-5, 0, -5, 0);
    self.descriptionView.editable = NO;
    self.descriptionView.scrollEnabled = NO;
    self.descriptionView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    self.descriptionView.textContainer.lineFragmentPadding = 0;
    self.descriptionView.textContainer.maximumNumberOfLines = 2;
    self.descriptionView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
