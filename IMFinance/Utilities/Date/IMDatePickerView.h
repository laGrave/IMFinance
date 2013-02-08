//
//  IMDatePickerView.h
//  IMFinance
//
//  Created by Igor Mishchenko on 08.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMDatePickerView;

@protocol IMDatePickerViewDelegate <NSObject>

- (void)datePicker:(IMDatePickerView *)picker didSelectDateParameters:(NSDictionary *)params;

@end

@interface IMDatePickerView : UIView

@property (nonatomic, strong) NSMutableDictionary *dateParams;
@property (nonatomic, weak) id <IMDatePickerViewDelegate> delegate;

- (id)initWithParams:(NSDictionary *)dateParams delegate:(id <IMDatePickerViewDelegate>)delegate;

@end
