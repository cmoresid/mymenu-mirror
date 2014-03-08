//
//  MMMenuItemPopOverViewController.h
//  MyMenu
//
//  Created by ninjavmware on 2014-02-13.
//
//

#import <UIKit/UIKit.h>
typedef void (^ratingsReturnBlock)(NSInteger);

/**
 *  Rating Popover Circle
 */
@interface MMMenuItemPopOverViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  <#Description#>
 */
@property (nonatomic, strong) NSArray * ratings;
@property (nonatomic) NSInteger rate;
@property (nonatomic, copy) ratingsReturnBlock returnBlock;
@property (nonatomic, weak) IBOutlet UIPickerView * ratingPicker;

- (IBAction)doneSelected:(id)sender;

@end
