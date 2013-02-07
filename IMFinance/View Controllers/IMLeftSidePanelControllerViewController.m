//
//  IMLeftSidePanelControllerViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMLeftSidePanelControllerViewController.h"

#import <UIViewController+JASidePanel.h>
#import "IMSidePanelController.h"

@interface IMLeftSidePanelControllerViewController ()

@end

@implementation IMLeftSidePanelControllerViewController

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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *storyboardID = @"";
    switch (indexPath.row) {
        case 0:
            storyboardID = @"summary view controller";
            break;
        case 1:
            storyboardID = @"accounts table view controller";
            break;
        case 2:
            storyboardID = @"transactions table view controller";
        default:
            break;
    }
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    IMSidePanelController *panelController = (IMSidePanelController *)self.sidePanelController;
    [panelController setCenterPanel:navVC];
}

@end
