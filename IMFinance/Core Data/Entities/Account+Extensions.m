//
//  Account+Extensions.m
//  IMFinance
//
//  Created by Igor Mishchenko on 04.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "Account+Extensions.h"
#import "Transaction.h"

@implementation Account (Extensions)

- (NSNumber *)value {
    
    double value = 0;
    NSArray *transactions = [Transaction MR_findByAttribute:@"account" withValue:self];
    
    for (Transaction *tr in transactions) {
        double transactionValue = [tr.value doubleValue];
        double fee = [tr.fee doubleValue];
        double mult = ([tr.incomeType boolValue]) ? 1 : -1;
        value += transactionValue * mult - fee;
    }
    
    return [NSNumber numberWithDouble:value];
}

@end
