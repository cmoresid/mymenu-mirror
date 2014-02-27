//
//  MMParentViewController.m
//  MyMenu
//
//  Created by Chris Moulds on 2/4/2014.
//
//

#import "MMSpecialsViewController.h"
#import "UIColor+MyMenuColors.h"

@interface MMSpecialsViewController ()

@end

@implementation MMSpecialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor darkTealColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
