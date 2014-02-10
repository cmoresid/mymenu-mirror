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


#define kCurrentUser @"currentUser"

@interface MMRestaurantViewController ()


@end

@implementation MMRestaurantViewController

NSArray *menuItems;

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


- (void)didRetrieveMenuItems:(NSArray *)menu withResponse:(MMDBFetcherResponse *)response{
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    }
    
}
- (void)viewDidLoad
{	
    [super viewDidLoad];
    //NSLog(@"Restaurant Name = @%@" , _selectedRestaurant.businessname);
    _restName.text = _selectedRestaurant.businessname;
    _restNumber.text = _selectedRestaurant.phone;
    menuItems = [[NSMutableArray alloc] init];
    
    	
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

//    MMMenuItem * tempItem = [[MMMenuItem alloc]init];
//    tempItem.name = @"Chicken + Wonton";
//    tempItem.cost = [NSNumber numberWithDouble:12.00];
//    
//    tempItem.picture = @"i.imgur.com/BfStevU.jpg";
//    tempItem.desc = @"this is so gd tasty";
//    tempItem.rating = [NSNumber numberWithDouble:9.3];
//    tempItem.restrictionflag = TRUE;
//    
//    [menuItems addObject:tempItem];
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    MMUser* userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getMenuWithMerchantId:[_selectedRestaurant.mid integerValue] withUserEmail:userProfile.email];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    


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
    return menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    MMMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuItemCell" owner:self options:NULL] objectAtIndex:0];
    }
    // Rounded Corners
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    
    MMMenuItem *menitem = [menuItems objectAtIndex:indexPath.row];
    
    //UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    //[imageView setImageWithURL:[NSURL URLWithString:menitem.picture] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    UIImage * temp = [[UIImage alloc] init];
    temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [menitem picture]]]];
    [cell.menuImageView setImage:temp];
    
    //[imageView temp];
    //[cell.menuImageView setImageWithURL:[NSURL URLWithString:[menitem picture]] placeholderImage:[UIImage imageNamed:@"restriction_placeholder.png"]];
    // Set the text
    
    
    UILabel *textTitle = (UILabel *) [cell viewWithTag:101];
    UILabel *textDesc = (UILabel *) [cell viewWithTag:102];
    UILabel * textPrice = (UILabel *) [cell viewWithTag:103];
    UILabel * textRating = (UILabel *) [cell viewWithTag:104];
    UILabel * textMod = (UILabel *) [cell viewWithTag:105];
    UIView * labelBack = (UIView * ) [cell viewWithTag:106];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:3];
    labelBack.backgroundColor = [UIColor lightBackgroundGray];
	labelBack.layer.cornerRadius = 5;
    textPrice.text = [formatter  stringFromNumber:menitem.cost];
    textRating.text = [formatter  stringFromNumber:menitem.rating];
    textTitle.text = menitem.name;
    textDesc.text = menitem.desc;
    if (menitem.restrictionflag == FALSE){
        textMod.hidden = TRUE;
    }
    //[textDesc sizeToFit];
    
    return cell;
}



// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}
@end
