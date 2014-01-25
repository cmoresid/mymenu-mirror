//
//  MMRegistrationViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMRegistrationViewController.h"

@interface MMRegistrationViewController ()

@end

@implementation MMRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.cityPicker.delegate = self;
    self.provPicker.delegate = self;
    self.genderPicker.delegate = self;
    self.cities = [[NSArray alloc]initWithObjects:@"Choose City", @"Edmonton", @"Calgary", @"Vancouver", nil];
    self.provinces = [[NSArray alloc]initWithObjects: @"Choose Province", @"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick", @"Newfoundland", @"Northwest Territories", @"Nova Scotia", @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatewan", @"Yukon",  nil];
    self.gender = [[NSArray alloc] initWithObjects: @"Choose Your Gender", @"Unspecified", @"Male", @"Female", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue*)segue
{
    NSLog(@"Dismiss...");
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (self.cityPicker == pickerView)
        return _cities.count;
    else
        if (self.provPicker == pickerView)
            return _provinces.count;
        else
            return _gender.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (self.cityPicker == pickerView)
        return _cities[row];
    else
        if (self.provPicker == pickerView)
            return _provinces[row];
        else
            return _gender[row];
}
    

@end
