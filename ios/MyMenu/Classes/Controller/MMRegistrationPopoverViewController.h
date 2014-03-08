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

/**
 *  The Cities the user can choose from
 */
@property(nonatomic, strong) NSArray *cities;

/**
 *   Provinces the users can choose from
 */
@property(nonatomic, strong) NSArray *provinces;

/**
 *  Genders the user can choose from
 */
@property(nonatomic, strong) NSArray *gender;


/**
 *  The UIPickerView for city selection.
 */
@property(nonatomic, weak) IBOutlet UIPickerView *cityPicker;

/**
 *  The UIPickerView for Province Selection
 */
@property(nonatomic, weak) IBOutlet UIPickerView *provPicker;

/**
 *  The UIPickerView for gender selection.
 */
@property(nonatomic, weak) IBOutlet UIPickerView *genderPicker;

/**
 *  UIDatePicker for birthday.
 */
@property(nonatomic, weak) IBOutlet UIDatePicker *birthdayPicker;

/**
 *  Selected value which the user chose, depending on the view
 */
@property(readwrite) MMPopoverDataPair *popoverValue;

/**
 *  Sets the Delegate for the popover controller
 */
@property(nonatomic, strong) id <MMRegistrationPopoverDelegate> delegate;

/**
 *  Updates the selected birthday
 */
- (void)updateSelectedBirthday;

/**
 *  Selected choice is registered.
 *
 *  @param sender
 */
- (IBAction)selectChoice:(id)sender;

@end