//
//  MMMenuItemViewController.m
//  MyMenu
//
//  Created by ninjavmware on 2014-02-10.
//
//

#import "MMMenuItemViewController.h"
#import "MMMenuItem.h"
#import "MBProgressHUD.h"
#import "UIColor+MyMenuColors.h"
#import "MMDBFetcher.h"
#import "MMMenuItemCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMRestaurantViewController.h"


#define kCurrentUser @"currentUser"
#define kSelectedRestaurant @"kSelectedRestaurant"

@interface MMMenuItemViewController ()

@end

@implementation MMMenuItemViewController

NSArray *menuItems;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveRestaurant:) name:kSelectedRestaurant object:nil];
    menuItems = [[NSMutableArray alloc] init];
    NSUserDefaults *perfs = [NSUserDefaults standardUserDefaults];
    NSData * currentUser = [perfs objectForKey:kCurrentUser];
    MMUser* userProfile = (MMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:currentUser];
    [MMDBFetcher get].delegate = self;
    [[MMDBFetcher get] getMenuWithMerchantId:[_selectedRestaurant.mid integerValue] withUserEmail:userProfile.email];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
	// Do any additional setup after loading the view.
}
- (void)recieveRestaurant:(NSNotification *)notification {
    _selectedRestaurant = (MMMerchant *) notification.object;
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
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

@end
