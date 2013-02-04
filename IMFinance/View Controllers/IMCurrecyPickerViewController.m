//
//  IMCurrecyPickerViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 04.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCurrecyPickerViewController.h"

#import "CurrencyConfig.h"

@interface IMCurrecyPickerViewController () <CurrencyConfigDelegate>

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

    self.currenciesConfig = [[CurrencyConfig alloc] init];
    self.currenciesConfig.delegate = self;
    [self.currenciesConfig loadExchangeRates];
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
    NSString *curLocale = [[self.currenciesConfig currenciesList] objectAtIndex:indexPath.row];
    NSDecimalNumber *rate = [self.currenciesConfig.exchangeRates objectForKey:curLocale];

    cell.textLabel.text = curLocale;
    cell.detailTextLabel.text = (rate) ? [NSString stringWithFormat:@"%@", rate] : @"";
    
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


#pragma mark -
#pragma mark - CurrencyConfigDelegate protocol implementation

- (void)currencyConfigDidLoadExchangeRates:(CurrencyConfig *)currencyConfig {

    [self.tableView reloadData];
}

@end
