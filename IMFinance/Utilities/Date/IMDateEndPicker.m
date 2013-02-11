//
//  IMDateEndPicker.m
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMDateEndPicker.h"

@interface IMDateEndPicker()

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetBarButtonItem;


@end

@implementation IMDateEndPicker

- (id)initWithDate:(NSDate *)endDate delegate:(id <IMDateEndPickerDelegate>)delegate {

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = [views lastObject];
    if (self) {
        self.delegate = delegate;
        
        [self.pickerView setMinimumDate:[NSDate date]];
        
        if (endDate) [self.pickerView setDate:endDate animated:NO];
    }
    return self;
}


- (IBAction)pickerDidSelectDate:(UIDatePicker *)sender {
    
    [self.delegate endDatePickerDidSelectDate:sender.date];
}


- (IBAction)doneButtonPressed:(id)sender {
    
    [self.delegate endDatePickerShouldDismiss:self];
}


- (IBAction)resetButtonPressed:(id)sender {
    
    [self.delegate endDatePickerDidResetDate];
}


@end
