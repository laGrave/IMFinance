//
//  IMDateStartPicker.h
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDateStartPicker;

@protocol IMDateStartPickerDelegate <NSObject>

- (void)startDatePickerDidSelectDate:(NSDate *)startDate;
- (void)startDatePickerShouldDismiss:(IMDateStartPicker *)picker;

@end

@interface IMDateStartPicker : UIView

@property (nonatomic, weak) id <IMDateStartPickerDelegate> delegate;

- (id)initWithDate:(NSDate *)startDate delegate:(id <IMDateStartPickerDelegate>)delegate;

@end
