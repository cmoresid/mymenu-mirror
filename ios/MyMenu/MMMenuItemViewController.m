//
//  MMMenuItemViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-11.
//
//

#import "MMMenuItemViewController.h"
#import "UIColor+MyMenuColors.h"
#import "MMRestaurantViewController.h"
#import "MMMerchant.h"

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
    _itemDescription.text = _touchedItem.desc;
    [_itemDescription setTextColor:[UIColor blackColor]];
    [_itemDescription setFont:[UIFont systemFontOfSize:24.0]];
    _itemImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _touchedItem.picture]]];
    _itemView.backgroundColor = [UIColor lightBackgroundGray];
	_itemView.layer.cornerRadius = 17.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"backToRestPage"]){
        MMRestaurantViewController *restaurantController = [segue destinationViewController];
        restaurantController.selectedRestaurant = _selectedRestaurant;
        
    }
}

@end
