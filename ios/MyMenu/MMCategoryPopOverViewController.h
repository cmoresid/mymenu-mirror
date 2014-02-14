//
//  MMCategoryPopOverViewController.h
//  MyMenu
//
//  Created by Chris Moulds on 2/13/2014.
//
//

#import <UIKit/UIKit.h>
#import "MMDBFetcherDelegate.h"
typedef void (^categoryReturnBlock)(NSString *);

@interface MMCategoryPopOverViewController : UIViewController <UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MMDBFetcherDelegate>



@property (nonatomic, weak) IBOutlet UIPickerView * pickerView;
@property (nonatomic, copy) categoryReturnBlock returnBlock;

-(IBAction)doneButton:(id)sender;

@end
