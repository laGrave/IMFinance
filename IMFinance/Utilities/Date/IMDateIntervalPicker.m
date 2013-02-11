//
//  IMDateIntervalPickerView.m
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMDateIntervalPicker.h"

@interface IMDateIntervalPicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *fixedIntervalKeys;
@property (nonatomic, strong) NSArray *customIntervalKeys;

@end

@implementation IMDateIntervalPicker

- (id)initWithInterval:(NSInteger)interval delegate:(id <IMDateIntervalPickerDelegate>)delegate {

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"IMDateIntervalPicker" owner:nil options:nil];
    self = [views objectAtIndex:0];
    if (self) {
        dispatch_queue_t initQueue = dispatch_queue_create("INIT QUEUE", NULL);
        dispatch_async(initQueue, ^{
            self.delegate = delegate;
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DateIntervalKeys" ofType:@"plist"];
            self.fixedIntervalKeys = [NSArray arrayWithContentsOfFile:plistPath];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:366];
            for (int i = 0; i < 366; i++) {
                [array addObject:[NSNumber numberWithInt:i]];
            }
            self.customIntervalKeys = [NSArray arrayWithArray:array];
            
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pickerView reloadAllComponents];
            });
            
            
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pickerView selectRow:rowNumber inComponent:0 animated:NO];
                    if (rowNumber == 9) {
                        [self.pickerView selectRow:interval inComponent:1 animated:NO];
                    } else [self.pickerView selectRow:0 inComponent:1 animated:NO];
                });
            }
        });
    }
    return self;
}


- (IBAction)doneButtonPressed:(id)sender {
    
    [self.delegate intervalPickerShouldDismiss:self];
}


#pragma mark -
#pragma mark - UIPickerViewDataSource protocol implementation

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) return self.fixedIntervalKeys.count;
    else return self.customIntervalKeys.count;
}


#pragma mark -
#pragma mark - UIPickerViewDelegate protocol ipmementation

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        NSString *key = [self.fixedIntervalKeys objectAtIndex:row];
        NSString *dateInterval = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:@"DateIntervals"];
        return dateInterval;
    }
    else return [NSString stringWithFormat:@"%@", [self.customIntervalKeys objectAtIndex:row]];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger interval = 0;
    if (component == 0) {
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
                interval = [self.pickerView selectedRowInComponent:1];
                break;
            default:
                interval = 0;
                break;
        }
    }
    if (component == 1) {
        [self.pickerView selectRow:9 inComponent:0 animated:YES];
        interval = row;
    }
    
    [self.delegate intervalPickerDidSelectInterval:interval];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    static NSInteger pickerBorder = 20;
    static NSInteger customIntervalCompWidth = 60;
    if (component == 1) {
        return customIntervalCompWidth;
    }
    return pickerView.bounds.size.width - 2 * pickerBorder - customIntervalCompWidth;
}


@end
