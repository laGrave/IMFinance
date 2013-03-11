//
//  IMTransactionEditViewController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 07.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transaction, Account;

@interface IMTransactionEditViewController : UIViewController

@property (nonatomic, strong) NSString *accountKey;
@property (nonatomic, strong) NSString *transactionKey;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) Transaction *transaction;
@end
