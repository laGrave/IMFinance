//
//  Transaction.h
//  IMFinance
//
//  Created by Игорь Мищенко on 12.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Category, Contractor;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * incomeType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * repeatInterval;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * modDate;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Contractor *contractor;

@end
