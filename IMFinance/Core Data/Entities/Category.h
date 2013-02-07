//
//  Category.h
//  IMFinance
//
//  Created by Igor Mishchenko on 07.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Transaction;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * budget;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
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
