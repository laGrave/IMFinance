//
//  IMCategoriesPickerViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 22.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoriesPickerViewController.h"

#import "Category.h"

@interface IMCategoriesPickerViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation IMCategoriesPickerViewController

#pragma mark -
#pragma mark - Getters

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [Category MR_fetchAllSortedBy:@"order" ascending:NO withPredicate:nil groupBy:@"incomeType" delegate:self];
    
    return _fetchedResultsController;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.fetchedResultsController.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = NSLocalizedString(category.name, nil);
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate categoriesPickerDidSelectCategory:category];
}

@end
