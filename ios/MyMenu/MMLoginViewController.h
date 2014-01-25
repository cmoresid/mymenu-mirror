//
//  MMLoginViewController.h
//  MyMenu
//
//  Created by Connor Moreside on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailAddress;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *activeField;

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue*)segue;
- (IBAction)login:(id)sender;

@end
