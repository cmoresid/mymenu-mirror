//
//  MMLocationPopoverViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPopoverDataPair.h"
#import "MMRegistrationPopoverDelegate.h"
#import "MMRegistrationViewController.h"

@interface MMRegistrationPopoverViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) NSArray *cities;
@property(nonatomic, strong) NSArray *provinces;
@property(nonatomic, strong) NSArray *gender;

@property(nonatomic, weak) IBOutlet UIPickerView *cityPicker;
@property(nonatomic, weak) IBOutlet UIPickerView *provPicker;
@property(nonatomic, weak) IBOutlet UIPickerView *genderPicker;
@property(nonatomic, weak) IBOutlet UIDatePicker *birthdayPicker;

@property(readwrite) MMPopoverDataPair *selectedValue;
@property(nonatomic, strong) UITextField *popoverField;
@property(nonatomic, strong) id <MMRegistrationPopoverDelegate> delegate;

- (void)updateSelectedBirthday;

- (IBAction)selectChoice:(id)sender;

@end
