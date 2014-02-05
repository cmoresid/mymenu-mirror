//
//  MMSettingsViewController.h
//  MyMenu
//
//  Created by Chris Moulds on 2/4/2014.
//
//

#import <UIKit/UIKit.h>

@interface MMSettingsViewController : UIViewController

@property(nonatomic,weak) IBOutlet UIButton *login;
@property(nonatomic,weak) IBOutlet UIButton *logout;

- (IBAction)logout:(id)sender;
- (IBAction)login:(id)sender;

@end
