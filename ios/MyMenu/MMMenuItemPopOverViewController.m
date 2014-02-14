//
//  MMMenuItemPopOverViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-13.
//
//

#import "MMMenuItemPopOverViewController.h"

@interface MMMenuItemPopOverViewController ()

@end

@implementation MMMenuItemPopOverViewController

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
    self.ratingPicker.dataSource = self;
    self.ratingPicker.delegate = self;
    self.ratings =[[NSArray alloc] initWithObjects:@"Your Rating", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
}
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.ratings.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.ratings[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != 0){
        self.rate = row;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneSelected:(id)sender{
    
    self.returnBlock(self.rate);
    
}

@end
