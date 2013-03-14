//
//  IMAccountSelectorController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 07.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@protocol IMAccountSelectorControllerDelegate <NSObject>

- (void)selectorDidSelectAccount:(Account *)account;

@end

@interface IMAccountSelectorController : UITableViewController

@property (nonatomic, weak) id <IMAccountSelectorControllerDelegate> delegate;

@end
