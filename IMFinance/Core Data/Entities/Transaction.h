//
//  Transaction.h
//  IMFinance
//
//  Created by Igor Mishchenko on 28.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Category, Contractor, Date;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * currency;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSString * geo;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * userImagePath;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Contractor *contractor;
@property (nonatomic, retain) Date *date;

@end
