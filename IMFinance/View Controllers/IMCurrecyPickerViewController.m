//
//  IMCurrecyPickerViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 04.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCurrecyPickerViewController.h"

#import "CurrencyConfig.h"

@interface IMCurrecyPickerViewController ()

@property (nonatomic, strong) CurrencyConfig *currenciesConfig;

@end

@implementation IMCurrecyPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"RUB" forKey:@"default currency code"];

    self.currenciesConfig = [[CurrencyConfig alloc] init];
    [self.currenciesConfig loadExchangeRatesWithSuccess:^(NSDictionary *rates){
                                                      [self.tableView reloadData];
                                                }
                                                  error:^(NSError *error, NSDictionary *oldRates){
                                                      NSLog(@"error during loading rates: %@", error.description);
                                                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.currenciesConfig currenciesList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *curCode = [[self.currenciesConfig currenciesList] objectAtIndex:indexPath.row];
    NSString *curName = [self.currenciesConfig currencyNameWithCode:curCode];
    NSString *rate = [self.currenciesConfig exchangeRateForCurrencyByDefaultCurrency:curCode];

    cell.textLabel.text = curName;
    cell.detailTextLabel.text = rate;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
