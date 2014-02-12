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
#import "MMDBFetcher.h"
#import "MMMenuItemCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMMenuItemViewController.h"


#define kCurrentUser @"currentUser"
#define kSelectedRestaurant @"kSelectedRestaurant"

@interface MMRestaurantViewController ()


@end

@implementation MMRestaurantViewController


NSArray *menuItems;
MMMenuItem * touchedItem;

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

    menuItems = [[NSArray alloc] init];
    [self.collectionView setDelegate:self];
    _restName.text = _selectedRestaurant.businessname;
    _restNumber.text = _selectedRestaurant.phone;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedRestaurant
                                                        object:_selectedRestaurant];
    
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
    NSString * rate =[formatter  stringFromNumber:_selectedRestaurant.rating];
    //NSNumber * rate = _selectedRestaurant.rating;
    if ([rate isEqualToString:@"0"]){
        rate = @"N/A";
    }
    _restRating.text = rate;
    
    menuItems = [[NSMutableArray alloc] init];
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    MMUser* userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getMenuWithMerchantId:[_selectedRestaurant.mid integerValue] withUserEmail:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}


    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return menuItems.count;
    }
    
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *identifier = @"Cell";
        
        MMMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:NULL] objectAtIndex:0];
        }
        // Rounded Corners
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.cornerRadius = 5;
        cell.contentView.layer.masksToBounds = YES;
        
        MMMenuItem *menitem = [menuItems objectAtIndex:indexPath.row];
        
        UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
        [imageView setImageWithURL:[NSURL URLWithString:menitem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
        // Set the text
        UILabel *textTitle = (UILabel *) [cell viewWithTag:101];
        textTitle.numberOfLines = 2;
        [textTitle sizeToFit];
        UILabel *textDesc = (UILabel *) [cell viewWithTag:102];
        UILabel * textPrice = (UILabel *) [cell viewWithTag:103];
        UILabel * textRating = (UILabel *) [cell viewWithTag:104];
        UILabel * textMod = (UILabel *) [cell viewWithTag:105];
        UIView * labelBack = (UIView * ) [cell viewWithTag:106];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:3];
        NSNumberFormatter *formatterCost = [[NSNumberFormatter alloc] init];
        [formatterCost setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatterCost setMaximumFractionDigits:3];
        [formatterCost setMinimumFractionDigits:2];
        labelBack.backgroundColor = [UIColor lightBackgroundGray];
        labelBack.layer.cornerRadius = 5;
        textPrice.text = [NSString stringWithFormat:@"$%@", [formatterCost  stringFromNumber:menitem.cost]];
        textRating.text = [formatter  stringFromNumber:menitem.rating];
        textTitle.text = menitem.name;
        textDesc.text = menitem.desc;
        cell.menuItem = menitem;
        if (menitem.restrictionflag == FALSE){
            textMod.text = @"";
        }else{
            textMod.text = @"!";
        }
        
        
        return cell;
    }
    
    - (void)didRetrieveMenuItems:(NSArray *)menu withResponse:(MMDBFetcherResponse *)response{
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        if (!response.wasSuccessful) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Communication Error"
                                                              message:@"Unable to communicate with server."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
            return;
        }else{
            menuItems = menu;
            [self.collectionView reloadData];
        }
        
    }
    
    
    // I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
    - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        // If you need to use the touched cell, you can retrieve it like so
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        MMMenuItemCell * itemCell = (MMMenuItemCell *) cell;
        NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
        touchedItem = [[MMMenuItem alloc ]init];
        touchedItem = itemCell.menuItem;

        [self performSegueWithIdentifier:@"showMenuItem" sender:self];

    }
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showMenuItem"]){
        MMMenuItemViewController *menuItemController = [segue destinationViewController];
        menuItemController.touchedItem = touchedItem;
        
    }
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
