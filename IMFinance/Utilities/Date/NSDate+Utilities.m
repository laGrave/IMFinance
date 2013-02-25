//
//  NSDate+Utilities.m
//  IMFinance
//
//  Created by Igor Mishchenko on 25.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

-(NSDate *)dateWithOutTime {

    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
