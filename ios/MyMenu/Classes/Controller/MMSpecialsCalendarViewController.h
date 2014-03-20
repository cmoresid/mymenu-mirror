//
//  MMSpecialsCalendarViewController.h
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-03-13.
//
//

#import <UIKit/UIKit.h>
#import <TimesSquare.h>
@class MMSpecialsCollectionViewController;

@interface MMSpecialsCalendarViewController : UIViewController <TSQCalendarViewDelegate>

/**
 *   The selected week
 */
@property(nonatomic) NSDate * selectedDate;

/**
 *  The controller we are in (Always MMSpecialsCollectionViewController)
 */
@property(nonatomic, readwrite) MMSpecialsCollectionViewController *specialsCollectionController;

/**
 *  Used for Displaying the Calendar
 */
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic,strong) NSDate * firstDate;


/**
 *  Required height for the tableview
 *
 *  @return CGSize use in View.
 */
- (CGSize)contentSizeForViewInPopover;


@end
