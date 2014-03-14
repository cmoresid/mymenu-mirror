//
//  MMSpecialsCalendarViewController.m
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-03-13.
//
//

#import "MMSpecialsCalendarViewController.h"
#import "MMSpecialsCollectionViewController.h"
#import "TSQTACalendarRowCell.h"
#import <TimesSquare/TimesSquare.h>

@interface MMSpecialsCalendarViewController ()
@property (nonatomic, retain) NSTimer *timer;
@end

@interface TSQCalendarView (AccessingPrivateStuff)

@property (nonatomic, readonly) UITableView *tableView;


@end

@implementation MMSpecialsCalendarViewController


- (void)loadView;
{
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
    calendarView.calendar = self.calendar;
    calendarView.rowCellClass = [TSQTACalendarRowCell class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:0];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor clearColor];
    calendarView.pagingEnabled = YES;
	calendarView.delegate = self;
	calendarView.selectedDate = self.selectedDate;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    self.view = calendarView;

	
}

- (void)viewDidLayoutSubviews
{
	// Set the calendar view to show today date on star
	

	//[(TSQCalendarView *)self.view scrollToDate:self.selectedDate animated:NO];
}

- (void)setCalendar:(NSCalendar *)calendar;
{
    _calendar = calendar;
}

- (void)scroll;
{
    static BOOL atTop = YES;
    TSQCalendarView *calendarView = (TSQCalendarView *)self.view;
    UITableView *tableView = calendarView.tableView;
    
    [tableView setContentOffset:CGPointMake(0.f, atTop ? 10000.f : 0.f) animated:YES];
    atTop = !atTop;
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGSize)contentSizeForViewInPopover {
    // Currently no way to obtain the width dynamically before viewWillAppear.
    CGFloat width = 200.0;
	CGRect rect = CGRectZero;
    CGFloat height = CGRectGetMaxY(rect);
    return (CGSize) {width, height};
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {
	self.selectedDate = date;
	[self.specialsCollectionController setSelectedDate:date];
	[self.specialsCollectionController loadSelectedDate];
}

@end
