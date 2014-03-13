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

@interface MMDietaryRestrictionCell ()

- (void)configureImageWithMask;

@end

@implementation MMDietaryRestrictionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        [self configureImageWithMask];
        
        self.restrictionImageView.image = self.restrictionImageWithMask;
    }
    else {
        self.restrictionImageView.image = self.restrictionImageWithoutMask;
    }
    
    _isSelected = isSelected;
}

- (void)configureImageWithMask {
    if (self.restrictionImageWithMask) {
        return;
    }
    
    self.restrictionImageWithMask = [UIImage addRestrictionMask:self.restrictionImageWithoutMask];
}

@end
