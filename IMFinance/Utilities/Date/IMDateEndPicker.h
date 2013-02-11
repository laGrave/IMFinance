//
//  IMDateEndPicker.h
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDateEndPicker;

@protocol IMDateEndPickerDelegate <NSObject>

- (void)endDatePickerDidSelectDate:(NSDate *)endDate;
- (void)endDatePickerDidResetDate;
- (void)endDatePickerShouldDismiss:(IMDateEndPicker *)picker;

@end

@interface IMDateEndPicker : UIView

@property (nonatomic, weak) id <IMDateEndPickerDelegate> delegate;

- (id)initWithDate:(NSDate *)endDate delegate:(id <IMDateEndPickerDelegate>)delegate;

@end
