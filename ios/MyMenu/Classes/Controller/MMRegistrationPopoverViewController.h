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

#import <UIKit/UIKit.h>
#import "MMPopoverDataPair.h"
#import "MMRegistrationPopoverDelegate.h"

/**
 Registration Popover View Controller class.
 Used for popover view elements in the registration page.
 Tied to MMRegistrationViewController.
 */
@interface MMRegistrationPopoverViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) NSArray *cities;
@property(nonatomic, strong) NSArray *provinces;
@property(nonatomic, strong) NSArray *gender;

@property(nonatomic, weak) IBOutlet UIPickerView *cityPicker;
@property(nonatomic, weak) IBOutlet UIPickerView *provPicker;
@property(nonatomic, weak) IBOutlet UIPickerView *genderPicker;
@property(nonatomic, weak) IBOutlet UIDatePicker *birthdayPicker;

@property(readwrite) MMPopoverDataPair *popoverValue;
@property(nonatomic, strong) id <MMRegistrationPopoverDelegate> delegate;

- (void)updateSelectedBirthday;

- (IBAction)selectChoice:(id)sender;

@end