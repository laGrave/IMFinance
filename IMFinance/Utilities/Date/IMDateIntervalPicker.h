//
//  IMDateIntervalPickerView.h
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDateIntervalPicker;

@protocol IMDateIntervalPickerDelegate <NSObject>

- (void)intervalPickerDidSelectInterval:(NSInteger)interval;
- (void)intervalPickerShouldDismiss:(IMDateIntervalPicker *)picker;

@end

@interface IMDateIntervalPicker : UIView

@property (nonatomic, weak) id <IMDateIntervalPickerDelegate> delegate;

- (id)initWithInterval:(NSInteger)interval delegate:(id <IMDateIntervalPickerDelegate>)delegate;


@end
