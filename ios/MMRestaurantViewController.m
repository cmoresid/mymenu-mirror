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
    _restNumber.text = _selectedRestaurant.phone;
    _restRating.text = [_selectedRestaurant.rating stringValue];
    _restDescription.text = _selectedRestaurant.desc;
    _restImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _selectedRestaurant.picture]]];
    
    NSLog(@"?????");

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
