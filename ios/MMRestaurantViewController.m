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
#import "MMMenuItem.h"
#import "MBProgressHUD.h"
#import "UIColor+MyMenuColors.h"
//#import "SDWebImage/UIImageView+WebCache.h"


@interface MMRestaurantViewController ()


@end

@implementation MMRestaurantViewController


static NSString * menuCateogires = {@"Dinner", @"Breakfast", @"Lunch", @"Dessert", @"Drink", @"Appetizer"};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) foodCategoryChanged:(UISegmentedControl *)sender {
    
}

- (void)viewDidLoad
{	
    [super viewDidLoad];
    //NSLog(@"Restaurant Name = @%@" , _selectedRestaurant.businessname);
    _restName.text = _selectedRestaurant.businessname;
    _restNumber.text = _selectedRestaurant.phone;
    
    	
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:3];
    //NSLog(@"%@",[formatter  stringFromNumber:_selectedRestaurant.rating]);

    for (UIView *subView in self.search.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here

                searchBarTextField.textColor = [UIColor whiteColor];
                searchBarTextField.font = [UIFont systemFontOfSize:22.0];
                searchBarTextField.tintColor = [UIColor whiteColor];
                searchBarTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search By Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                UIImage *magna = [UIImage imageNamed:@"06-magnify.png"];
                UIImageView * mag = [[UIImageView alloc] initWithImage:magna];
                searchBarTextField.leftView = mag;
               
                
                break;
            }
        }
    }
    
    [_restDescription  setText:_selectedRestaurant.desc];

    [_restDescription setTextColor:[UIColor whiteColor]];
    [_restDescription setFont:[UIFont systemFontOfSize:24.0]];
    _restImage.image = [UIImage imageWithData:                                                                      [NSData dataWithContentsOfURL:                                                                            [NSURL URLWithString: _selectedRestaurant.picture]]];
    _ratingView.backgroundColor = [UIColor lightBackgroundGray];
	_ratingView.layer.cornerRadius = 17.5;
    _restRating.text = [formatter  stringFromNumber:_selectedRestaurant.rating];


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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Rounded Corners
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    
    MMMenuItem *menitem = [_menuItems objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    //[imageView setImageWithURL:[NSURL URLWithString:[menitem picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    
    // Set the text
    UITextView *textView = (UITextView *) [cell viewWithTag:101];
    UITextView *textDesc = (UITextView *) [cell viewWithTag:102];
    textView.text = menitem.name;
    textDesc.text = menitem.desc;
    [textDesc sizeToFit];
    
    return cell;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}
@end
