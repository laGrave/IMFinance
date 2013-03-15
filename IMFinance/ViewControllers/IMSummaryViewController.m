//
//  IMSummaryViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMSummaryViewController.h"

@interface IMSummaryViewController () <PFLogInViewControllerDelegate>

@end

@implementation IMSummaryViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Instance methods

- (IBAction)loginButtonPressed:(UIBarButtonItem *)sender {
    
    PFLogInViewController *loginVC = [[PFLogInViewController alloc] init];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:YES completion:NULL];
}


#pragma mark -
#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
