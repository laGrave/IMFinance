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

    return [NSLocale ISOCurrencyCodes];
}


- (void)loadExchangeRates {
    
    // initialize rate array
    self.exchangeRates = [[NSMutableDictionary alloc] init];
    
    // Load and parse the rates.xml file
    [TBXML tbxmlWithURL:[NSURL URLWithString:@"http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"]
                success:^(TBXML *tbxml){
                    // If TBXML found a root node, process element and iterate all children
                    if (tbxml.rootXMLElement)
                        [self traverseElement:tbxml.rootXMLElement];
                    
                    // add EUR to rate table
                    [self.exchangeRates setObject:@"1.0" forKey:@"EUR"];
                    
                    if ([self.delegate conformsToProtocol:@protocol(CurrencyConfigDelegate)]) {
                        [self.delegate currencyConfigDidLoadExchangeRates:self];
                    }
                }
                failure:^(TBXML *tbxml, NSError *error){
                    NSLog(@"error %@", error.description);
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


@end
