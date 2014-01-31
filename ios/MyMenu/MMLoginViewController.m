//
//  MMLoginViewController.m
//  MyMenu
//
//  Created by Connor Moreside on 1/23/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMLoginViewController.h"
#import "MMUser.h"
#import "MMDBFetcher.h"

// Only used for testing
#define USER_LOGGED_IN  0

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

- (void)viewDidAppear:(BOOL)animated {
    if (USER_LOGGED_IN) {
        [self performSegueWithIdentifier:@"moveToMainScreen" sender:self];
    }
    else {
        self.view.hidden = FALSE;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailAddress.delegate = self;
    self.password.delegate = self;

    // Hide by default; only show if user is
    // not logged in.
    self.view.hidden = TRUE;

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

    MMDBFetcher *fetcher = [[MMDBFetcher get] init];
    NSInteger resultCode = [fetcher userVerified:user];

    if (resultCode > 0)
        [self performSegueWithIdentifier:@"moveToMainScreen" sender:self];
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username or Password!"
                                                          message:@"Please enter a valid user name and password."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

@end
