//
//  IMCategoriesTableViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 23.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoriesTableViewController.h"

#import <UIViewController+JASidePanel.h>

#import "IMCategoryEditViewController.h"
#import "IMSidePanelController.h"
#import "IMTransactionsTableViewController.h"

@interface IMCategoriesTableViewController ()

@property (nonatomic) BOOL changeIsUserDriven;

@property (nonatomic, strong) NSMutableDictionary *sections;
@property (nonatomic, strong) NSMutableDictionary *sectionToTypeMap;

@end

@implementation IMCategoriesTableViewController


#pragma mark -
#pragma mark - View Controller lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.className = @"Category";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToTypeMap = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Order by type
    [query orderByAscending:@"type"];
    [query addAscendingOrder:@"order"];
    return query;
}


- (NSString *)typeForSection:(NSInteger)section {
    return [self.sectionToTypeMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToTypeMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *type = [NSString stringWithFormat:@"%@", [object objectForKey:@"type"]];
        NSMutableArray *objectsInSection = [self.sections objectForKey:type];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this sportType - increment the section index
            [self.sectionToTypeMap setObject:type forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:type];
    }
    
    [self.tableView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sportType = [self typeForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:sportType];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *type = [self typeForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:type];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *type = [self typeForSection:section];
    return type;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    NSString *name = [object objectForKey:@"name"];
    cell.textLabel.text = NSLocalizedString(name, NULL);
    
    return cell;
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
        PFObject *object = [self objectAtIndexPath:indexPath];
        [object deleteInBackgroundWithBlock:^(BOOL success, NSError *error){
            if (success) {
                [self loadObjects];            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    self.changeIsUserDriven = YES;
    

    
    self.changeIsUserDriven = NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
     
     return YES;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    PFObject *object = [self objectAtIndexPath:indexPath];
    
    IMCategoryEditViewController *categoryEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"IMCategoryEditViewController"];
    [categoryEdit setObjectId:object.objectId];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:categoryEdit];
    [self presentViewController:navVC animated:YES completion:NULL];
}

@end
