//
//  MMMenuItemViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-11.
//
//

#import "MMMenuItemViewController.h"

@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController

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
    _itemName.text = _touchedItem.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
