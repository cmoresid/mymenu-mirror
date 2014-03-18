//
//  MMMenuItemCollectionViewFlowLayout.m
//  MyMenu
//
//  Created by Connor Moreside on 3/14/2014.
//
//

#import "MMMenuItemCollectionViewFlowLayout.h"

@implementation MMMenuItemCollectionViewFlowLayout

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    
    
    if (size.height < (self.collectionView.frame.size.height + self.viewHeight)) {
        size.height = self.collectionView.frame.size.height + self.viewHeight;
    }
    
    return size;
}

@end
