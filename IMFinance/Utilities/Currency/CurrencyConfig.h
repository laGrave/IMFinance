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

- (NSArray *)currenciesList;

//получаем курсы валют онлайн
- (void)loadExchangeRates;


@end
