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

#import "MMLoginViewController.h"
#import "MMUser.h"
#import "MMDBFetcher.h"

#define kCurrentUser @"currentUser"

@interface MMLoginViewController ()

@end

@implementation MMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse *)response
{
    if (resultCode > 0) {
        [[MMDBFetcher get] getUser:self.emailAddress.text];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username or Password!"
                                                          message:@"Please enter a valid user name and password."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)didRetrieveUser:(MMUser *)user withResponse:(MMDBFetcherResponse *)response
{
    NSUserDefaults * userPreferances = [NSUserDefaults standardUserDefaults];
    NSData * encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userPreferances setObject:encodedUser forKey:kCurrentUser];
    [self performSegueWithIdentifier:@"moveToMainScreen" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    
    if (currentUser != nil) {
        [self performSegueWithIdentifier:@"moveToMainScreen" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailAddress.delegate = self;
    self.password.delegate = self;
    [MMDBFetcher get].delegate = self;


    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    kbSize.height = kbSize.height / 1.7f;
    kbSize.width = kbSize.width / 1.7f;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return (action == @selector(unwindToLoginScreen:));
}

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    // Perform any saving if necessary.
}

- (IBAction)login:(id)sender {

    MMUser *user = [[MMUser alloc] init];
    if (([self.emailAddress.text isEqualToString:@""] || self.emailAddress.text == nil) || ([self.password.text isEqualToString:@""] || self.password.text == nil)) {
        NSLog(@"shfdkjshflshldgkhan");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username or Password!"
                                                          message:@"Please enter a valid user name and password."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else {
        user.email = self.emailAddress.text;
        user.password = self.password.text;
        
    }

    MMDBFetcher *fetcher = [MMDBFetcher get];
    [fetcher userVerified:user];
}


@end
