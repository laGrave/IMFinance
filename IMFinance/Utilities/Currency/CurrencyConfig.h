//
//  CurrencyConfig.h
//  furniture
//
//  Created by Игорь Мищенко on 26.07.12.
//
//

#import <Foundation/Foundation.h>

@interface CurrencyConfig : NSObject

@property (nonatomic, strong) NSMutableDictionary *exchangeRates;

//список международных кодов всех валют в программе
- (NSArray *)currenciesList;

//код валюты, выбранной пользователем по умолчанию
- (NSString *)defaultCurrencyCode;

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
- (void)loadExchangeRatesWithSuccess:(void(^)(NSDictionary *exchangeRates))successHandler
                               error:(void(^)(NSError *error, NSDictionary *oldRates))errorHandler;


@end
