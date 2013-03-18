//
//  Account.h
//  IMFinance
//
//  Created by Igor Mishchenko on 18.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"

@class Transaction;

@interface Account : SyncObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSDate * modDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
