//
//  MMRestaurantViewController.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-01.
//
//

#import <UIKit/UIKit.h>
#import "MMMerchant.h"

@interface MMRestaurantViewController : UIViewController



@property(nonatomic, retain) MMMerchant *selectedRestaurant;
@property(nonatomic) IBOutlet UILabel * restName;
@property(nonatomic) IBOutlet UILabel * restNumber;
@property(nonatomic) IBOutlet UILabel * restRating;
@property(nonatomic) IBOutlet UILabel * restDescription;
@property(nonatomic) IBOutlet UIImageView * restImage;

@end

