//
//  IMCurrenciesListTableViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 25.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMCurrenciesListTableViewController.h"

#import "CurrencyConfig.h"

@interface IMCurrenciesListTableViewController ()

@property (nonatomic, strong) NSArray *currenciesList;

@end

@implementation IMCurrenciesListTableViewController

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

    self.currenciesList = [CurrencyConfig currenciesList];
    [self.tableView reloadData];
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

    return [self.currenciesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *currencyName = [self.currenciesList objectAtIndex:indexPath.row];
    cell.textLabel.text = currencyName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currencyKey = [CurrencyConfig currencyKeyByNumber:[NSNumber numberWithInteger:indexPath.row]];
    [self.delegate currenciesListDidSelectCurrency:currencyKey];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
