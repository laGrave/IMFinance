//
//  IMDateStartPicker.m
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMDateStartPicker.h"

@interface IMDateStartPicker()

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *yesterdayButton;

@property (nonatomic, strong) NSDate *date;

@end

@implementation IMDateStartPicker


- (id)initWithDate:(NSDate *)startDate delegate:(id <IMDateStartPickerDelegate>)delegate {

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = [views lastObject];
    if (self) {
        self.delegate = delegate;
        if (startDate) [self.pickerView setDate:startDate animated:NO];
    }
    return self;
}


- (IBAction)doneButtonPressed:(id)sender {
    
    [self.delegate startDatePickerShouldDismiss:self];
}


- (IBAction)todayButtonPressed:(id)sender {
    
    [self.pickerView setDate:[NSDate date] animated:YES];
}


- (IBAction)yesterdayButtonPressed:(id)sender {
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    [self.pickerView setDate:yesterday animated:YES];
}


- (IBAction)pickerDidSelectDate:(UIDatePicker *)sender {
    
    [self.delegate startDatePickerDidSelectDate:sender.date];
}


@end
