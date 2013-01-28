//
//  IMAccountsListTableViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 26.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMAccountsListTableViewController.h"
#import "Account.h"
#import "IMTransactionsTableViewController.h"

@interface IMAccountsListTableViewController ()

@property (nonatomic, strong) NSArray *accountsList;

@end

@implementation IMAccountsListTableViewController

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.accountsList = [Account MR_findAll];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[Account MR_findAll] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Account *account = [[Account MR_findAll] objectAtIndex:indexPath.row];
    cell.textLabel.text = account.name;
    
    return cell;
}

//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
                Account *accountToDelete = [[Account MR_findAllInContext:localContext] objectAtIndex:indexPath.row];
                [accountToDelete MR_deleteInContext:localContext];
            }
                              completion:^(BOOL success, NSError *error){
                                  if (error) {
                                      ;
                                  }
                                  else {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                          self.accountsList = [Account MR_findAll];
                                      });
                                  }
                              }];

        });
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Account *account = [self.accountsList objectAtIndex:indexPath.row];

    IMTransactionsTableViewController *transactionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IMTransactionsTableViewController"];
    transactionsVC.accountKey = account.key;
    [self.navigationController pushViewController:transactionsVC animated:YES];
}

@end
