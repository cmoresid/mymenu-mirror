//
//  MMRegistrationViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/24/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMRegistrationViewController.h"
#import "MMDBFetcher.h"
#import "MMUser.h"
#import "MMRegistrationPopoverViewController.h"

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
    self.cityField.delegate = self;
    self.genderField.delegate = self;
    self.provinceField.delegate = self;
    self.birthdayField.delegate = self;
    
    self.userProfile = [[MMUser alloc] init];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    MMRegistrationPopoverViewController *locationContent = [self getPopoverViewControllerForTextField:textField];
    locationContent.delegate = self;
    locationContent.popoverField = textField;
    
    UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:locationContent];
    
    popover.popoverContentSize = [self getPopoverViewSizeForTextField:textField];
    popover.delegate = self;
    
    self.locationPopoverController = popover;
    
    [self.locationPopoverController presentPopoverFromRect:textField.frame
                                                    inView:textField.superview
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
    
    return FALSE;
}

- (void)didSelectValue:(MMPopoverDataPair *)selectedValue
{
    switch (selectedValue.dataType) {
        case CityValue:
            self.userProfile.city = selectedValue.selectedValue;
            break;
        case GenderValue:
            self.userProfile.gender = (selectedValue.selectedValue != nil)
                ? [selectedValue.selectedValue characterAtIndex:0] : 'U';
            break;
        case ProvinceValue:
            // TODO: Store this in another object.
            break;
        case BirthdayValue:
            //self.birthdayField.text = [self convertDateToString:selectedValue.selectedValue];
            break;
        default:
            break;
    }
    
    [self.locationPopoverController dismissPopoverAnimated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    // Don't allow user to manually dismiss modal controller
    return FALSE;
}

- (id)getPopoverViewControllerForTextField:(UITextField*)textField
{
    if (textField == self.cityField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"CityPopoverViewController"];
    else if (textField == self.provinceField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"ProvincePopoverViewController"];
    else if (textField == self.genderField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"GenderPopoverViewController"];
    else if (textField == self.birthdayField)
        return [self.storyboard instantiateViewControllerWithIdentifier:@"BirthdayPopoverViewController"];
    
    return nil;
}

- (CGSize)getPopoverViewSizeForTextField:(UITextField*)textField
{
    if (textField == self.birthdayField)
        return CGSizeMake(450.0f, 220.0f);
    else
        return CGSizeMake(350.0f, 200.0f);
}

@end
