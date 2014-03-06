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

#import <UIKit/UIKit.h>
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMRestaurantPopOverDelegate.h"

@class MMRestaurantPopOverViewController;

/** The restaurant view controller.
 This displays a single restaurant in detail.
 Information such as restaurant name, rating, description, etc.
 This is where the restaurant's menu is displayed.
 This view will also allow the user to filter through the menu,
 either by rating, category or name.
*/
@interface MMRestaurantViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MMDBFetcherDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, MMRestaurantPopOverDelegate>



@property MMMerchant *selectedRestaurant;
@property(nonatomic, weak) IBOutlet UILabel * restName; // restaurant name
@property(nonatomic, weak) IBOutlet UILabel * restNumber; // restaurant phone number
@property(nonatomic, weak) IBOutlet UILabel * restRating; // restaurant rating
@property(nonatomic, weak) IBOutlet UITextView * restDescription; // restaurant description
@property(nonatomic, weak) IBOutlet UIImageView * restImage; // restaurant image
@property(nonatomic, weak) IBOutlet UIView *ratingView; // rounded background for restaurant rating
@property(nonatomic, weak) IBOutlet UISearchBar * search; // field for search by name
@property(nonatomic, weak) IBOutlet UIButton * categoryButton; // filter by category buttton
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView; // the menu collection
@property(nonatomic, weak) IBOutlet UINavigationBar *navigationBar;//the navigation bar at the top of the screen
@property(nonatomic, weak) IBOutlet UICollectionView *reviewCollection; //review collection view
@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl; //review segemented control
@property(nonatomic, weak) IBOutlet UILabel * hours;
@property(nonatomic, weak) IBOutlet UILabel * adress;
@property (nonatomic, strong) UIPopoverController * popOverController;
@property (nonatomic, strong) MMRestaurantPopOverViewController * restPopOver;


-(IBAction)categoryClear:(id)sender;
-(IBAction)searchClear:(id)sender;
-(IBAction)categoryPicker:(id)sender;
@end

