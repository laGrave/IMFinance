//
//  CurrencyConfig.h
//  furniture
//
//  Created by Игорь Мищенко on 26.07.12.
//
//

#import <Foundation/Foundation.h>

@class CurrencyConfig;

@protocol CurrencyConfigDelegate <NSObject>

- (void)currencyConfigDidLoadExchangeRates:(CurrencyConfig *)currencyConfig;

@end

@interface CurrencyConfig : NSObject

@property (nonatomic, strong) NSMutableDictionary *exchangeRates;
@property (nonatomic, weak) id <CurrencyConfigDelegate> delegate;

//список международных кодов всех валют в программе
- (NSArray *)currenciesList;

//название валюты по ее коду на выбранном языке
- (NSString *)currencyNameWithCode:(NSString *)code inLocale:(NSLocale *)locale;
//название валюты по ее коду на текущем языке системы
- (NSString *)currencyNameWithCode:(NSString *)code;


//обменный курс конкретной валюты по отношению к евро
- (NSString *)exchangeRateForCurrencyByEuro:(NSString *)currencyCode;
//обменный курс конкретной валюты по отношению к системной валюте
- (NSString *)exchangeRateForCurrencyByDefaultCurrency:(NSString *)currencyCode;
//обменный курс конкретной валюты по отношению к другой валюте
- (NSString *)exchangeRateForCurrency:(NSString *)firstCurCode
                           byCurrency:(NSString *)secondCurCode;

//получаем курсы валют онлайн
- (void)loadExchangeRates;


@end
