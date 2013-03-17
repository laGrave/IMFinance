//
//  IMTransactionsTableViewController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category, Account;

@interface IMTransactionsTableViewController : UITableViewController

@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) Account *account;

@end
