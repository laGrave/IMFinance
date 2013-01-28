//
//  IMCurrenciesListTableViewController.h
//  IMFinance
//
//  Created by Игорь Мищенко on 25.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMCurrenciesListTableViewControllerDelegate <NSObject>

- (void)currenciesListDidSelectCurrency:(NSString *)currencyKey;

@end

@interface IMCurrenciesListTableViewController : UITableViewController

@property (nonatomic, weak) id <IMCurrenciesListTableViewControllerDelegate> delegate;

@end
