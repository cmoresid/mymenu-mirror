//
//  MMCategoryPopOverViewController.m
//  MyMenu
//
//  Created by Chris Moulds on 2/13/2014.
//
//

#import "MMCategoryPopOverViewController.h"
#import "MMDBFetcher.h"
#import "MMDBFetcherDelegate.h"
#import "MBProgressHUD.h"

@interface MMCategoryPopOverViewController ()

@end

@implementation MMCategoryPopOverViewController

NSString * category;
NSArray * allCategories;

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
    allCategories = [[NSArray alloc] init];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getCategories];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
}

- (void)didRetrieveCategories:(NSArray *)categories withResponse:(MMDBFetcherResponse *)response{
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    if (!response.wasSuccessful) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                          message:@"Unable to communicate with server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }else{
        allCategories = categories;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return allCategories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return allCategories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    category = allCategories[row];
}
    
    
- (IBAction)doneButton:(id)sender{
        
    self.returnBlock(category);
    
}
    




@end
