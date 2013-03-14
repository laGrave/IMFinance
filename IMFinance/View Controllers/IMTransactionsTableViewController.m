//
//  IMTransactionsTableViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMTransactionsTableViewController.h"

#import "Transaction.h"
#import "Category.h"
#import "Account.h"

#import "IMTransactionEditViewController.h"
#import "IMTransactionCell.h"

@interface IMTransactionsTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation IMTransactionsTableViewController


#pragma mark -
#pragma mark - Getters

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSPredicate *predicate;
    if (self.account) {
        Account *account = [self.account MR_inThreadContext];
        predicate = [NSPredicate predicateWithFormat:@"account == %@", account];
    }
    else if (self.category) {
        Category *category = [self.category MR_inThreadContext];
        predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
    }
    else predicate = nil;
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"hidden == %@", [NSNumber numberWithBool:NO]];
    aPredicate = (predicate) ? [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:aPredicate, predicate, nil]] : aPredicate;
    
    _fetchedResultsController = [Transaction MR_fetchAllSortedBy:@"startDate" ascending:NO withPredicate:aPredicate groupBy:@"startDate" delegate:self];
    
    return _fetchedResultsController;
}

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Instance Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"edit transaction"] && self.account) {
        UINavigationController *navVC = (UINavigationController *)segue.destinationViewController;
        IMTransactionEditViewController *transactionEditVC = (IMTransactionEditViewController *)[navVC topViewController];
        transactionEditVC.account = self.account;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Transaction *trans = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *Cell = @"Cell";
    NSString *Detailed = (trans.name.length) ? @"Detailed" : @"";
    NSString *Fee = (trans.fee.doubleValue != 0) ? @"WithFee" : @"";
    NSString *identifier = [NSString stringWithFormat:@"%@%@%@", Detailed, Cell, Fee];
    IMTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([trans.name length]) {
        cell.textLabel.text = trans.name;
        cell.detailedTextLabel.text = NSLocalizedString(trans.category.name, @"");
    }
    else cell.textLabel.text = NSLocalizedString(trans.category.name, @"");
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:trans.currency];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundCeiling];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:trans.value]];
    cell.feeLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:trans.fee]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    Transaction *trans = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    return [dateFormatter stringFromDate:trans.startDate];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Transaction *transToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [transToDelete MR_deleteEntity];
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {    
    
    Transaction *trans = [self.fetchedResultsController objectAtIndexPath:indexPath];
    IMTransactionEditViewController *transEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Transaction Edit Controller"];
    transEditVC.transaction = trans;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:transEditVC];
    [self presentViewController:navVC animated:YES completion:NULL];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}


#pragma mark -
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
