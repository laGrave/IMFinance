//
//  IMCategoriesTableViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 23.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoriesTableViewController.h"

#import <UIViewController+JASidePanel.h>

#import "Category.h"

#import "IMCategoryEditViewController.h"
#import "IMSidePanelController.h"
#import "IMTransactionsTableViewController.h"

@interface IMCategoriesTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL changeIsUserDriven;

@end

@implementation IMCategoriesTableViewController

#pragma mark -
#pragma mark - Getters

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
//    _fetchedResultsController = [Category MR_fetchAllGroupedBy:@"incomeType" withPredicate:nil sortedBy:@"order" ascending:YES delegate:self];
//    _fetchedResultsController = [Category MR_fetchAllSortedBy:@"order" ascending:YES withPredicate:nil groupBy:@"incomeType" delegate:nil];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"order" cacheName:nil];
    
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    
    return _fetchedResultsController;
}


#pragma mark -
#pragma mark - View Controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *cats = [Category MR_findAllSortedBy:@"order" ascending:YES];
    for (Category *cat in cats) {
        NSLog(@"category name: %@", cat.name);
        NSLog(@"category order:  %@", cat.order);
        NSString *income = (cat.incomeType.boolValue) ? @"Доход" : @"Расход";
        NSLog(@"%@", income);
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark - Instance methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
    
    if (editing) {
        UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(addBarButtonItemPressed:)];
        [self.navigationItem setLeftBarButtonItem:addBarButtonItem];
    }
    else {
        IMSidePanelController *panelController = (IMSidePanelController *)self.sidePanelController;
        [self.navigationItem setLeftBarButtonItem:[panelController leftButtonForCenterPanel]];
    }
}


- (void)addBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {

    IMCategoryEditViewController *categoryEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"IMCategoryEditViewController"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:categoryEdit];
    [self presentViewController:navVC animated:YES completion:NULL];
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
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(category.name, @"");
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 1:
            return @"Доход";
            break;
            
        default:
            return @"Расход";
            break;
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //удаляем данную категорию из базы и производим пересортировку оставшихся
        
        Category *categoryToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [categoryToDelete MR_deleteEntity];
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
        
        NSMutableArray *categories = [[self.fetchedResultsController fetchedObjects] mutableCopy];
        
        int i = 0;
        for (Category *category in categories) {
            category.order = [NSNumber numberWithInteger:i];
            i++;
        }
        
        
        [context MR_saveToPersistentStoreAndWait];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    self.changeIsUserDriven = YES;
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSMutableArray *categories = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    Category *c = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
    
    [categories removeObject:c];
    [categories insertObject:c atIndex:toIndexPath.row];
        
    int i = 0;
    for (Category *category in categories) {
        category.order = [NSNumber numberWithInteger:i];
        i++;
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
    self.changeIsUserDriven = NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
     
     return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    Category *c = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    IMCategoryEditViewController *categoryEditVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([IMCategoryEditViewController class])];
    [categoryEditVC setCategory:c];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:categoryEditVC];
    [self presentViewController:navVC animated:YES completion:NULL];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Category *c = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    IMTransactionsTableViewController *transactionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"transactions table view controller"];
    transactionsVC.category = c;
    [self.navigationController pushViewController:transactionsVC animated:YES];
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}


#pragma mark -
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.changeIsUserDriven) return;
    
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (self.changeIsUserDriven) return;
    
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
    
    if (self.changeIsUserDriven) return;
    
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
    
    if (self.changeIsUserDriven) return;
    
    [self.tableView endUpdates];
}

@end
