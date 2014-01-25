//
//  MMRegistrationViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRegistrationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) IBOutlet UIPickerView* cityPicker;
@property (strong, nonatomic) NSArray* cities;
@property (nonatomic, weak) IBOutlet UIPickerView* provPicker;
@property (strong, nonatomic) NSArray* provinces;
@property (nonatomic, weak) IBOutlet UIPickerView* genderPicker;
@property (strong, nonatomic) NSArray* gender;


- (IBAction)unwindToLoginScreen:(UIStoryboardSegue*)segue;

@end
