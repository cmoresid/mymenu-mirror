//
//  MMMenuItemReviewCell.h
//  MyMenu
//
//  Created by ninjavmware on 2014-03-01.
//
//

#import <UIKit/UIKit.h>

@interface MMMenuItemReviewCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *reviewLabel;
@property(nonatomic, weak) IBOutlet UILabel *ratinglabel;
@property(nonatomic, weak) IBOutlet UIView *ratingBg;
@property(nonatomic, weak) IBOutlet UIImageView *likeImageView;
@property(nonatomic, weak) IBOutlet UIButton * reportButton;
@property(nonatomic, weak) IBOutlet UILabel * upVotes;

@end

