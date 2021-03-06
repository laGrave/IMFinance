//
//  Transaction.h
//  IMFinance
//
//  Created by Igor Mishchenko on 19.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"

@class Account, Category, Contractor;

@interface Transaction : SyncObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSNumber * incomeType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * repeatInterval;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Contractor *contractor;

@end
