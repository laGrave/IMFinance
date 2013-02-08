//
//  IMDatePickerView.m
//  IMFinance
//
//  Created by Igor Mishchenko on 08.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMDatePickerView.h"

static NSString *kDateStart = @"start date";
static NSString *kDateInterval = @"date interval";
static NSString *kDateEnd = @"end date";

@interface IMDatePickerView() <UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIToolbar *doneButton;

@property (weak, nonatomic) IBOutlet UIView *startAdditionView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *yesterdayButton;

@property (weak, nonatomic) IBOutlet UIView *intervalAdditionView;
@property (weak, nonatomic) IBOutlet UIPickerView *intervalPicker;
@property (weak, nonatomic) IBOutlet UILabel *intervalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *intervalDayLabel;
@property (weak, nonatomic) IBOutlet UIStepper *intervalStepper;

@property (weak, nonatomic) IBOutlet UIView *endDateAdditionView;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, strong) NSArray *dateIntervalKeys;

@end

@implementation IMDatePickerView

@synthesize dateParams = _dateParams;

- (id)initWithParams:(NSDictionary *)dateParams delegate:(id<IMDatePickerViewDelegate>)delegate {

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"IMDatePickerView" owner:nil options:nil];
    self = [views objectAtIndex:0];
    if (self) {
        
        self.delegate = delegate;
        
        [self.segmentedControl addTarget:self
                                  action:@selector(segmentChanged:)
                        forControlEvents:UIControlEventValueChanged];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DateIntervalKeys" ofType:@"plist"];
        self.dateIntervalKeys = [NSArray arrayWithContentsOfFile:plistPath];
        
        self.intervalPicker.dataSource = self;
        self.intervalPicker.delegate = self;
        [self.intervalPicker reloadAllComponents];
        
        self.intervalDayLabel.textColor = [UIColor grayColor];
        
        self.endDatePicker.minimumDate = [NSDate date];
        
        if (dateParams) {
            self.dateParams = [NSMutableDictionary dictionaryWithDictionary:dateParams];
            
            NSDate *startDate = [dateParams objectForKey:kDateStart];
            if (startDate) {
                [self.startDatePicker setDate:startDate animated:NO];
            }
            
            NSInteger interval = [[dateParams objectForKey:kDateInterval] integerValue];
            if (interval) {
                NSUInteger rowNumber;
                switch (interval) {
                    case 0:
                        rowNumber = 0;
                        break;
                    case 1:
                        rowNumber = 1;
                        break;
                    case 7:
                        rowNumber = 2;
                        break;
                    case 14:
                        rowNumber = 3;
                        break;
                    case -30:
                        rowNumber = 4;
                        break;
                    case -60:
                        rowNumber = 5;
                        break;
                    case -90:
                        rowNumber = 6;
                        break;
                    case -180:
                        rowNumber = 7;
                        break;
                    case -365:
                        rowNumber = 8;
                        break;
                    default:
                        rowNumber = 9;
                        break;
                }
                [self.intervalPicker selectRow:rowNumber inComponent:0 animated:NO];
                if (rowNumber == 9) {
                    self.intervalDayLabel.textColor = [UIColor blackColor];
                    self.intervalDayLabel.text = [NSString stringWithFormat:@"%i", interval];
                } else self.intervalDayLabel.textColor = [UIColor grayColor];
            }
            
            NSDate *endDate = [self.dateParams objectForKey:kDateEnd];
            if (endDate) {
                [self.endDatePicker setDate:endDate animated:NO];
            }
        }
    }
    return self;
}


- (NSMutableDictionary *)dateParams {

    if (!_dateParams) {
        _dateParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSDate date], kDateStart, [NSNumber numberWithInteger:0], kDateInterval, nil];
    }
    return _dateParams;
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self.delegate datePicker:self didSelectDateParameters:self.dateParams];
}


- (void)segmentChanged:(UISegmentedControl *)control {

    UIView *picker = nil;
    UIView *additionView = nil;
    
    switch (control.selectedSegmentIndex) {
        case 1:
            picker = self.intervalPicker;
            additionView = self.intervalAdditionView;
            break;
        case 2:
            picker = self.endDatePicker;
            additionView = self.endDateAdditionView;
            break;
        default:
            picker = self.startDatePicker;
            additionView = self.startAdditionView;
            break;
    }
    
    [self bringSubviewToFront:picker];
    [self bringSubviewToFront:additionView];
}


- (IBAction)yesterdayButtonPressed:(id)sender {
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    [self.startDatePicker setDate:yesterday animated:YES];
}


- (IBAction)todayButtonPressed:(id)sender {
    
    [self.startDatePicker setDate:[NSDate date] animated:YES];
}

- (IBAction)stepperPressed:(UIStepper *)sender {
    
    self.intervalDayLabel.textColor = [UIColor blackColor];
    self.intervalDayLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:sender.value]];
    
    [self.dateParams setValue:[NSNumber numberWithInt:sender.value] forKey:kDateInterval];
    
    NSInteger rowNumber = [self.intervalPicker numberOfRowsInComponent:0];
    if (rowNumber > 0) {
        rowNumber--;
    }
    [self.intervalPicker selectRow:rowNumber inComponent:0 animated:YES];
}

#pragma mark -
#pragma mark - UIPickerViewDataSource protocol implementation

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return self.dateIntervalKeys.count;
}


#pragma mark -
#pragma mark - UIPickerViewDelegate protocol ipmementation

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSString *key = [self.dateIntervalKeys objectAtIndex:row];
    NSString *dateInterval = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:@"DateIntervals"];
    return dateInterval;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    UIColor *labelColor = [UIColor grayColor];
    
    NSInteger interval = 0;
    switch (row) {
        case 1:
            interval = 1;
            break;
        case 2:
            interval = 7;
            break;
        case 3:
            interval = 14;
            break;
        case 4:
            interval = -30;
            break;
        case 5:
            interval = -60;
            break;
        case 6:
            interval = -90;
            break;
        case 7:
            interval = -180;
            break;
        case 8:
            interval = -365;
            break;
        case 9:
            interval = [self.intervalDayLabel.text integerValue];
            labelColor = [UIColor blackColor];
            break;
        default:
            interval = 0;
            break;
    }
    
    self.intervalDayLabel.textColor = labelColor;
    [self.dateParams setValue:[NSNumber numberWithInteger:interval] forKey:kDateInterval];
}

@end
