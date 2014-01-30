//
//  MMLocationPopoverViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
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

    self.cities = [[NSArray alloc] initWithObjects:@"Choose City", @"Edmonton", @"Calgary", @"Vancouver", nil];
    self.provinces = [[NSArray alloc] initWithObjects:@"Choose Province", @"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick", @"Newfoundland", @"Northwest Territories", @"Nova Scotia", @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatewan", @"Yukon", nil];
    self.gender = [[NSArray alloc] initWithObjects:@"Choose Your Gender", @"Unspecified", @"Male", @"Female", nil];

    self.selectedValue = nil;
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
    if (pickerView == self.cityPicker)
        self.selectedValue = [[MMPopoverDataPair alloc] initWithDataType:CityValue
                                                       withSelectedValue:self.cities[row]];
    else if (pickerView == self.provPicker)
        self.selectedValue = [[MMPopoverDataPair alloc] initWithDataType:ProvinceValue
                                                       withSelectedValue:self.provinces[row]];
    else if (pickerView == self.genderPicker)
        self.selectedValue = [[MMPopoverDataPair alloc] initWithDataType:GenderValue
                                                       withSelectedValue:self.gender[row]];
}

- (void)updateSelectedBirthday {
    self.selectedValue = [[MMPopoverDataPair alloc] initWithDataType:BirthdayValue
                                                   withSelectedValue:self.birthdayPicker.date];
}

- (IBAction)selectChoice:(id)sender {
    self.popoverField.text = [self convertToString:self.selectedValue];

    [self.delegate didSelectValue:self.selectedValue];
}

- (NSString *)convertToString:(MMPopoverDataPair *)data {
    if (data.dataType == BirthdayValue)
        return [self convertDateToString:data.selectedValue];
    else
        return data.selectedValue;

}

- (NSString *)convertDateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    return [dateFormatter stringFromDate:date];
}

@end
