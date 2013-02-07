//
//  Date.h
//  IMFinance
//
//  Created by Igor Mishchenko on 07.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Transaction;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Transaction *transaction;

@end
