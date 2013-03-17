//
//  TestVC.m
//  IMFinance
//
//  Created by Igor Mishchenko on 08.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "TestVC.h"

#import "IMDateIntervalPicker.h"
#import "IMDateStartPicker.h"
#import "IMDateEndPicker.h"

@interface TestVC () <IMDateIntervalPickerDelegate, IMDateStartPickerDelegate, IMDateEndPickerDelegate>

@end

@implementation TestVC

static NSString *kDateStart = @"start date";
static NSString *kDateInterval = @"date interval";
static NSString *kDateEnd = @"end date";

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
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSDate date], kDateStart, [NSNumber numberWithInteger:14], kDateInterval, nil];
    
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"IMDatePickerView" owner:nil options:nil];
//    IMDatePickerView *view = [views objectAtIndex:0];
//    IMDatePickerView *view = [[IMDatePickerView alloc] initWithParams:params delegate:self];
    
//    IMDateIntervalPicker *view = [[IMDateIntervalPicker alloc] initWithInterval:0 delegate:self];
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
//    IMDateStartPicker *view = [[IMDateStartPicker alloc] initWithDate:yesterday delegate:self];
    IMDateEndPicker *view = [[IMDateEndPicker alloc] initWithDate:yesterday delegate:self];
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - IMDateIntervalPickerViewDelegate protocol implementation

- (void)intervalPickerDidSelectInterval:(NSInteger)interval {

    NSLog(@"selected interval in days: %ld", (long)interval);
}


#pragma mark -
#pragma mark - IMDateStartPickerDelegate protocol implementation

- (void)startDatePickerDidSelectDate:(NSDate *)startDate {

    NSLog(@"selected date: %@", startDate);
}


#pragma mark -
#pragma mark - IMDateEndPickerDelegate protocol implementation

- (void)endDatePickerDidSelectDate:(NSDate *)endDate {

    NSLog(@"selected date %@", endDate);
}
@end
