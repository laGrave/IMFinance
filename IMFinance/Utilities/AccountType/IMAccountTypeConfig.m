//
//  IMAccountTypeConfig.m
//  IMFinance
//
//  Created by Igor Mishchenko on 28.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMAccountTypeConfig.h"

@implementation IMAccountTypeConfig

+ (NSArray *)typeList {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AccountTypes" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:plistPath];
}


+ (NSArray *)localizedTypeList {

    NSArray *arrayOfTypes = [IMAccountTypeConfig typeList];
    NSMutableArray *localizedArrayOfTypes = [NSMutableArray arrayWithCapacity:[arrayOfTypes count]];
    for (NSString *type in arrayOfTypes) {
        [localizedArrayOfTypes addObject:NSLocalizedString(type, @"")];
    }
    return localizedArrayOfTypes;
}

@end
