//
//  IMCurrecyPickerViewController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 04.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMCurrecyPickerViewControllerDelegate <NSObject>

- (void)pickerDidSelectCurrency:(NSString *)currencyCode;

@end

@interface IMCurrecyPickerViewController : UITableViewController

@property (nonatomic, weak) id <IMCurrecyPickerViewControllerDelegate> delegate;

@end
