//
//  MMDietaryRestrictionsViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMUser.h"

@interface MMDietaryRestrictionsViewController : UIViewController <UICollectionViewDataSource>

@property MMUser *userProfile;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UISwitch *onSwitch;


@end
