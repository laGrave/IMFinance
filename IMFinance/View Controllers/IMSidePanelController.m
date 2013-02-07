//
//  IMSidePanelController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMSidePanelController.h"

@interface IMSidePanelController ()

@end

@implementation IMSidePanelController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.leftFixedWidth = 100;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) awakeFromNib {
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"left side panel"]];
//    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"center panel"]];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"summary view controller"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self setCenterPanel:navVC];
}

@end
