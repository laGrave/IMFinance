//
//  CurrencyConfig.m
//  furniture
//
//  Created by Игорь Мищенко on 26.07.12.
//
//

#import "CurrencyConfig.h"

@implementation CurrencyConfig

+ (NSArray *)currenciesList {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    //NSLog(@"%@", currencies);
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *currency in reorderedArray) {
        [result addObject:[currency objectForKey:@"name"]];
    }
    return result;
}


+ (NSMutableArray*) reorderCurrencyArray:(NSArray*) array {
    
    NSMutableArray *result = [NSMutableArray arrayWithArray:array];
    NSMutableArray *result_ = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *currency in result_)
    {
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyRuble])
            [result replaceObjectAtIndex:0 withObject:currency];
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyDollar])
            [result replaceObjectAtIndex:1 withObject:currency];
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyEuro])
            [result replaceObjectAtIndex:2 withObject:currency];
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyTenge])
            [result replaceObjectAtIndex:3 withObject:currency];
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyHryvnia])
            [result replaceObjectAtIndex:4 withObject:currency];
        if([[currency objectForKey:@"id"] isEqualToString:kCurrencyBelRuble])
            [result replaceObjectAtIndex:5 withObject:currency];
    }
    [result removeObjectAtIndex:2];
    return result;
}

+ (NSString *)currencySignByName:(NSString *)currencyName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[currencies count]];
    
    NSUInteger indexOfCurrency = [reorderedArray indexOfObjectPassingTest:^(NSDictionary *currency, NSUInteger index, BOOL *stop){
        if ([currencyName isEqualToString:[currency objectForKey:@"name"]]) {
            *stop = YES;
            return YES;
        }
        else return NO;
    }];
    
    if (indexOfCurrency >= [result count]) {
        indexOfCurrency = 3;
    }
    NSDictionary *selectedCurrency = [reorderedArray objectAtIndex:indexOfCurrency];
    NSString *sign = [selectedCurrency valueForKey:@"sign"];
    return sign;
}


+ (NSString *)currencySignByNumber:(NSNumber *)currencyNumber {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    //NSLog(@"%@", currencies);
    NSDictionary *dicRes = [reorderedArray objectAtIndex:[currencyNumber integerValue]];
    NSString *result = [NSString stringWithString:[dicRes objectForKey:@"sign"]];
    return result;

}


+ (NSString *)currencyKeyByNumber:(NSNumber *)currencyNumber {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    //NSLog(@"%@", currencies);
    NSDictionary *dicRes = [reorderedArray objectAtIndex:[currencyNumber integerValue]];
    NSString *result = [NSString stringWithString:[dicRes objectForKey:@"key"]];
    return result;

}


+ (NSDictionary *)currencyByID:(NSString *)currencyID {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    
    NSUInteger indexOfCurrency = [reorderedArray indexOfObjectPassingTest:^(NSDictionary *currency, NSUInteger index, BOOL *stop){
        if ([currencyID isEqualToString:[currency objectForKey:@"id"]]) {
            *stop = YES;
            return YES;
        }
        else return NO;
    }];

    NSDictionary *selectedCurrency = [reorderedArray objectAtIndex:indexOfCurrency];
    return selectedCurrency;
}


+ (NSNumber*) currencyByNameForStorage:(NSString *)currencyName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    NSUInteger indexOfCurrency = [reorderedArray indexOfObjectPassingTest:^(NSDictionary *currency, NSUInteger index, BOOL *stop){
        if ([currencyName isEqualToString:[currency objectForKey:@"name"]]) {
            *stop = YES;
            return YES;
        }
        else return NO;
    }];
    return [NSNumber numberWithInteger:indexOfCurrency];
}




+ (NSDictionary *) currencyByNumber:(NSNumber *)currencyNumber {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    //NSLog(@"%@", currencies);
    NSDictionary *dicRes = [reorderedArray objectAtIndex:[currencyNumber integerValue]];
//    NSString *result = [NSString stringWithString:[dicRes objectForKey:@"name"]];
    return dicRes;
}


+ (NSDictionary *)currencyByName:(NSString *)currencyName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    NSUInteger indexOfCurrency = [reorderedArray indexOfObjectPassingTest:^(NSDictionary *currency, NSUInteger index, BOOL *stop){
        if ([currencyName isEqualToString:[currency objectForKey:@"name"]]) {
            *stop = YES;
            return YES;
        }
        else return NO;
    }];
    
    NSDictionary *selectedCurrency = [reorderedArray objectAtIndex:indexOfCurrency];
    return selectedCurrency;
}

+ (NSNumber *)currencyNumberByKey:(NSString *)key {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *currencies = [[NSDictionary dictionaryWithContentsOfFile:path] allValues];
    NSMutableArray *reorderedArray = [CurrencyConfig reorderCurrencyArray:currencies];
    NSUInteger indexOfCurrency = [reorderedArray indexOfObjectPassingTest:^(NSDictionary *currency, NSUInteger index, BOOL *stop){
        if ([key isEqualToString:[currency objectForKey:@"key"]]) {
            *stop = YES;
            return YES;
        }
        else return NO;
    }];
    
    return [NSNumber numberWithInteger:indexOfCurrency];
}


@end
