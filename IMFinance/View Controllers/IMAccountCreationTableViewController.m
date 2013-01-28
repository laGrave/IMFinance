//
//  IMAccountCreationTableViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 25.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMAccountCreationTableViewController.h"

#import "IMCurrenciesListTableViewController.h"
#import "MBAlertView.h"
#import "CurrencyConfig.h"
#import "Account.h"

#import "IMCoreDataManager.h"


static NSString *kAccountName = @"name";
static NSString *kAcccountCurrency = @"currency";
static NSString *kAccountValue = @"value";


@interface IMAccountCreationTableViewController () <IMCurrenciesListTableViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (nonatomic, strong) NSMutableDictionary *accountParams;

@end

@implementation IMAccountCreationTableViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.accountParams = [[NSMutableDictionary alloc] init];
    
    self.nameTextField.delegate = self;
    self.valueTextField.delegate = self;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"select currency"]) {
        IMCurrenciesListTableViewController *curList = segue.destinationViewController;
        curList.delegate = self;
    }
}


- (IBAction)cancelButtonPressed {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneButtonPressed {
    
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    if ([self.valueTextField isFirstResponder]) {
        [self.valueTextField resignFirstResponder];
    }
    
    BOOL check = [self checkParams];
    if (!check) {
        MBAlertView *alert = [MBAlertView alertWithBody:@"Пожалуйста, заполните все поля" cancelTitle:nil cancelBlock:nil];
        [alert addButtonWithText:@"Закрыть" type:MBAlertViewItemTypePositive block:nil];
        [alert addToDisplayQueue];
    }
    else {
        IMCoreDataManager *coreDataManager = [IMCoreDataManager sharedInstance];
        [coreDataManager addAccountInBackground:self.accountParams
                                    withSuccess:^{[self dismissViewControllerAnimated:YES completion:NULL];}
                                        failure:^(NSError *error){NSLog(@"error: %@", error.description);}];

    }
}


- (BOOL)checkParams {

    NSString *name = [self.accountParams valueForKey:kAccountName];
    NSNumber *value = [self.accountParams valueForKey:kAccountValue];
    NSNumber *currency = [self.accountParams valueForKey:kAcccountCurrency];
    
    return (name.length && value && currency) ? YES : NO;
}


#pragma mark -
#pragma mark IMCurrenciesListTableViewControllerDelegate protocol implementation

- (void)currenciesListDidSelectCurrency:(NSString *)currencyKey {

    [self.accountParams setValue:[CurrencyConfig currencyNumberByKey:currencyKey] forKey:kAcccountCurrency];
}


#pragma mark -
#pragma mark UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.nameTextField && textField.text.length) {
        [self.accountParams setValue:textField.text forKey:kAccountName];
    }
    if (textField == self.valueTextField && textField.text.doubleValue) {
        [self.accountParams setValue:[NSNumber numberWithDouble:textField.text.doubleValue] forKey:kAccountValue];
    }
}

@end
