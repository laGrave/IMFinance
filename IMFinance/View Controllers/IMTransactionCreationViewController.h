//
//  IMTransactionCreationViewController.h
//  IMFinance
//
//  Created by Igor Mishchenko on 28.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTransactionCreationViewController : UITableViewController

@property (nonatomic, strong) NSString *accountKey;

- (IBAction)cancelButtonPressed;
- (IBAction)doneButtonPressed;

@end
