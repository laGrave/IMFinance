//
//  Category.h
//  IMFinance
//
//  Created by Игорь Мищенко on 18.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"

@class Category, Transaction;

@interface Category : SyncObject

@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSNumber * incomeType;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * system;
@property (nonatomic, retain) Category *parent;
@property (nonatomic, retain) NSSet *subcategories;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addSubcategoriesObject:(Category *)value;
- (void)removeSubcategoriesObject:(Category *)value;
- (void)addSubcategories:(NSSet *)values;
- (void)removeSubcategories:(NSSet *)values;

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
