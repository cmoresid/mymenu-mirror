//
//  MMMenuItemCell.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-08.
//
//

#import <UIKit/UIKit.h>
#import "MMMenuItem.h"

@interface MMMenuItemCell : UICollectionViewCell

@property(nonatomic) MMMenuItem *menuItem;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *priceLabel;
@property(nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, weak) IBOutlet UILabel *ratinglabel;
@property(nonatomic, weak) IBOutlet UILabel *restrictionLabel;
@property(nonatomic, weak) IBOutlet UIView *ratingBg;
@property(nonatomic, weak) IBOutlet UIImageView *menuImageView;

@end
