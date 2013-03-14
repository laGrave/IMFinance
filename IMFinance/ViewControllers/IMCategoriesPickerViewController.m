//
//  IMCategoriesPickerViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 22.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoriesPickerViewController.h"

#import "Category.h"

@interface IMCategoriesPickerViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation IMCategoriesPickerViewController

#pragma mark -
#pragma mark - Controller's lifecycle

- (id)initWithIncomeType:(NSNumber *)incomeType delegate:(id <IMCategoriesPickerDelegate>)delegate {

    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        self.categories = [Category MR_findByAttribute:@"incomeType" withValue:incomeType andOrderBy:@"order" ascending:YES];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"incomeType == %@", incomeType];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"system == NO"];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
        self.categories = [Category MR_findAllSortedBy:@"order" ascending:YES withPredicate:predicate];
        self.delegate = delegate;
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Category *category = [self.categories objectAtIndex:indexPath.row];
    
    cell.textLabel.text = NSLocalizedString(category.name, nil);
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Category *category = [self.categories objectAtIndex:indexPath.row];
    [self.delegate categoriesPickerDidSelectCategory:category];
}

@end
