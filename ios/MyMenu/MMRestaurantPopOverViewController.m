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
#import "MMRestaurantPopOverViewController.h"

#define kCategories @"kCategories"

@interface MMRestaurantPopOverViewController ()

@end

@implementation MMRestaurantPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveCategories:)
                                                 name:kCategories
                                               object:nil];
    //self.categories = [[NSArray alloc] initWithObjects:@"none", @"1", @"2", nil];
    self.popoverValue = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) didReceiveCategories:(NSNotification *)notification{
    self.categories = notification.object;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {

        return _categories.count;

}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return _categories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        self.popoverValue = [[MMPopoverDataPair alloc] initWithDataType:CategoryValue
                                                      withSelectedValue:self.categories[row]];
}

- (IBAction)selectChoice:(id)sender {
    [self.delegate didSelectCategory:self.popoverValue.selectedValue];
}


@end
