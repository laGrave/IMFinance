//
//  Contractor.h
//  IMFinance
//
//  Created by Igor Mishchenko on 18.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"

@class Transaction;

@interface Contractor : SyncObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Contractor (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
