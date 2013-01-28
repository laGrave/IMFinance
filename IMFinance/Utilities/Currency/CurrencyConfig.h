//
//  CurrencyConfig.h
//  furniture
//
//  Created by Игорь Мищенко on 26.07.12.
//
//

#import <Foundation/Foundation.h>

#define kCurrencyRuble @"ruble"
#define kCurrencyDollar @"dollar"
#define kCurrencyEuro @"euro"
#define kCurrencyTenge @"tenge"
#define kCurrencyHryvnia @"hryvnia"
#define kCurrencyBelRuble @"belarusian ruble"
enum numbersValidCurrency {
    currencyTenge = 2,
    currencyBelRuble = 4,
    currencyHryvnia = 3,
    currencyDollar = 1,
    currencyEuro = 5,
    currencyRuble = 0
};

@class ProductPrice;
@class User, Series;

@interface CurrencyConfig : NSObject

+ (NSArray *)currenciesList;
+ (NSString *)currencySignByName:(NSString *)currencyName;
+ (NSString *)currencySignByNumber:(NSNumber *)currencyNumber;
+ (NSDictionary *)currencyByID:(NSString *)currencyID;
+ (NSDictionary *)currencyByName:(NSString *)currencyName;
+ (NSString *)currencyKeyByNumber:(NSNumber *)currencyNumber;
+ (NSNumber *)currencyNumberByKey:(NSString *)key;


@end
