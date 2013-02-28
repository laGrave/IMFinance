//
//  IMTransactionsTableViewController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@interface IMTransactionsTableViewController : UITableViewController

@property (nonatomic, strong) NSString *accountKey;
@property (nonatomic, strong) NSString *categoryKey;
@property (nonatomic, strong) Category *category;

@end
