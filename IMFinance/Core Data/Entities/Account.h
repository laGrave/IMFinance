//
//  Account.h
//  IMFinance
//
//  Created by Igor Mishchenko on 28.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, Transaction;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * accountNumber;
@property (nonatomic, retain) NSString * bankName;
@property (nonatomic, retain) NSNumber * cardNumber;
@property (nonatomic, retain) NSNumber * currency;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * pinCode;
@property (nonatomic, retain) NSNumber * secutityCode;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) Date *date;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
