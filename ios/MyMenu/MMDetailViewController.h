//
//  MMDetailViewController.h
//  Master
//
//  Created by Chris Pavlicek on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMDetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate>

@property(strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (void) pinRestaurants;

@end
