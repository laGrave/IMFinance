//
//  Account.m
//  IMFinance
//
//  Created by Игорь Мищенко on 23.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "Account.h"
#import "Transaction.h"


@implementation Account

@dynamic currency;
@dynamic image;
@dynamic key;
@dynamic limit;
@dynamic name;
@dynamic startDate;
@dynamic type;
@dynamic initialValue;
@dynamic currentValue;
@dynamic transactions;

- (NSNumber *)currentValue {

    NSArray *transactions = [Transaction MR_findByAttribute:@"account" withValue:self];
    double curVal = [self.initialValue doubleValue];
    for (Transaction *trans in transactions) {
        double transValue = [trans.value doubleValue];
        double transMult = (trans.incomeType.boolValue) ? 1 : -1;
        curVal += transValue * transMult;
    }
    return [NSNumber numberWithDouble:curVal];
}

@end
