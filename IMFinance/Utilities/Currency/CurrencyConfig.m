//
//  CurrencyConfig.m
//  furniture
//
//  Created by Игорь Мищенко on 26.07.12.
//
//

#import "CurrencyConfig.h"

#import <TBXML+HTTP.h>
#import "TBXML+HTTP.h"

@implementation CurrencyConfig

- (NSArray *)currenciesList {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:plistPath];
}


- (NSString *)defaultCurrencyCode {

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"default currency code"];
}


- (void)loadExchangeRatesWithSuccess:(void(^)(NSDictionary *exchangeRates))successHandler
                               error:(void(^)(NSError *error, NSDictionary *oldRates))errorHandler {

    
    // Load and parse the rates.xml file
    [TBXML tbxmlWithURL:[NSURL URLWithString:@"http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"]
                success:^(TBXML *tbxml){
                    // initialize new rate array
                    self.exchangeRates = [[NSMutableDictionary alloc] init];
                    
                    // If TBXML found a root node, process element and iterate all children
                    if (tbxml.rootXMLElement)
                        [self traverseElement:tbxml.rootXMLElement];
                    
                    // add EUR to rate table
                    [self.exchangeRates setObject:@"1.0" forKey:@"EUR"];
                    
                    successHandler(self.exchangeRates);
                }
                failure:^(TBXML *tbxml, NSError *error){
                    NSLog(@"error %@", error.description);
                    errorHandler(error, self.exchangeRates);
                }];

}


- (void) traverseElement:(TBXMLElement *)element {
    
    do {
        // Display the name of the element
        //NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        NSString *currencyName;
        while (attribute) {
            /* Display name and value of attribute to the log window
             NSLog(@"%@->%@ = %@",
             [TBXML elementName:element],
             [TBXML attributeName:attribute],
             [TBXML attributeValue:attribute]);
             */
            // store currency
            if ([[TBXML attributeName:attribute] isEqualToString: @"currency"]) {
                currencyName = [TBXML attributeValue:attribute];
            }else if ([[TBXML attributeName:attribute] isEqualToString: @"rate"]) {
                // store currency and rate in dictionary
                [self.exchangeRates setObject:[TBXML attributeValue:attribute] forKey:currencyName];
            }
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
}


- (NSString *)currencyNameWithCode:(NSString *)code inLocale:(NSLocale *)locale {

    NSLocale *loc = locale;
    if (!loc) {
        locale = [NSLocale autoupdatingCurrentLocale];
    }
    
    return [locale displayNameForKey:NSLocaleCurrencyCode value:code];
}


- (NSString *)currencyNameWithCode:(NSString *)code {

    return [self currencyNameWithCode:code inLocale:nil];
}


- (NSString *)exchangeRateForCurrencyByEuro:(NSString *)currencyCode {

    NSString *rate = [self.exchangeRates objectForKey:currencyCode];
    return (rate.length) ? rate : @"";
}


- (NSString *)exchangeRateForCurrencyByDefaultCurrency:(NSString *)currencyCode {

    NSString *defaultCurCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"default currency code"];
    if (!defaultCurCode) defaultCurCode = @"EUR";
    
    return [self exchangeRateForCurrency:currencyCode byCurrency:defaultCurCode];
}


- (NSString *)exchangeRateForCurrency:(NSString *)firstCurCode
                           byCurrency:(NSString *)secondCurCode {

    NSString *firstRate  = [self exchangeRateForCurrencyByEuro:firstCurCode];
    NSString *secondRate = [self exchangeRateForCurrencyByEuro:secondCurCode];

    if (firstRate.length && secondRate.length) {
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:firstRate];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:secondRate];
        return [[b decimalNumberByDividingBy:a] stringValue];
    }
    else return @"";
}

@end
