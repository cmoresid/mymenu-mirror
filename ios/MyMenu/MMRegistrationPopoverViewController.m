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

#import "MMRegistrationPopoverViewController.h"

@interface MMRegistrationPopoverViewController ()

@end

@implementation MMRegistrationPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityPicker.delegate = self;
    self.provPicker.delegate = self;
    self.genderPicker.delegate = self;
    [self.birthdayPicker addTarget:self
                            action:@selector(updateSelectedBirthday)
                  forControlEvents:UIControlEventValueChanged];
    self.birthdayPicker.maximumDate = [NSDate date];

    self.cities = [[NSArray alloc] initWithObjects:@"Choose City", @"Edmonton", nil];
    self.provinces = [[NSArray alloc] initWithObjects:@"Choose Province", @"Alberta", nil];
    self.gender = [[NSArray alloc] initWithObjects:@"Choose Your Gender", @"Unspecified", @"Male", @"Female", nil];

    self.popoverValue = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:
        (UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (self.cityPicker == pickerView)
        return _cities.count;
    else if (self.provPicker == pickerView)
        return _provinces.count;
    else
        return _gender.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (self.cityPicker == pickerView)
        return _cities[row];
    else if (self.provPicker == pickerView)
        return _provinces[row];
    else
        return _gender[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.cityPicker && row > 0)
        self.popoverValue = [[MMPopoverDataPair alloc] initWithDataType:CityValue
                                                      withSelectedValue:self.cities[row]];
    else if (pickerView == self.provPicker && row > 0)
        self.popoverValue = [[MMPopoverDataPair alloc] initWithDataType:ProvinceValue
                                                      withSelectedValue:self.provinces[row]];
    else if (pickerView == self.genderPicker && row > 0)
        self.popoverValue = [[MMPopoverDataPair alloc] initWithDataType:GenderValue
                                                      withSelectedValue:self.gender[row]];
    else
        self.popoverValue = nil;
}

- (void)updateSelectedBirthday {
    self.popoverValue = [[MMPopoverDataPair alloc] initWithDataType:BirthdayValue
                                                  withSelectedValue:self.birthdayPicker.date];
}

- (IBAction)selectChoice:(id)sender {
    switch (self.popoverValue.dataType) {
        case CityValue:
            [self.delegate didSelectCity:self.popoverValue.selectedValue];
            break;

        case GenderValue:
            [self.delegate didSelectGender:self.popoverValue.selectedValue];
            break;

        case ProvinceValue:
            [self.delegate didSelectProvince:self.popoverValue.selectedValue];
            break;

        case BirthdayValue:
            [self.delegate didSelectBirthday:self.popoverValue.selectedValue];
            break;

        default:
            break;
    }
}

@end
