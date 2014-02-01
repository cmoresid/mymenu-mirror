//
//  MMRestaurantViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-01.
//
//

#import "MMRestaurantViewController.h"

@interface MMRestaurantViewController ()

@end

@implementation MMRestaurantViewController

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
    NSLog(@"Restaurant Name = @%@" , _selectedRestaurant.businessname);
    _restName.text = _selectedRestaurant.businessname;
    _restNumber.text = _selectedRestaurant.businessnumber;
    _restRating.text = _selectedRestaurant.rating;
    _restDescription.text = _selectedRestaurant.desc;
    _restImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _selectedRestaurant.picture]]];
    
    

	// Do any additional setup after loading the view.
}

- (void)setViews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
