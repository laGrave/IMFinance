//
//  IMTransactionCreationViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 28.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMTransactionCreationViewController.h"

#import "IMCurrenciesListTableViewController.h"
#import "MBAlertView.h"
#import "CurrencyConfig.h"
#import "Account.h"

#import "IMCoreDataManager.h"


static NSString *kTransactionName = @"name";
static NSString *kTransactionValue = @"value";
static NSString *kTransactionCurrency = @"currency";
static NSString *kTransactionAccountKey = @"account key";

@interface IMTransactionCreationViewController () <IMCurrenciesListTableViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (nonatomic, strong) NSMutableDictionary *tParams;

@end

@implementation IMTransactionCreationViewController


- (void)setAccountKey:(NSString *)accountKey {

    [self.tParams setValue:self.accountKey forKey:kTransactionAccountKey];
}

- (NSMutableDictionary *)tParams {

    if (!_tParams) {
        _tParams = [[NSMutableDictionary alloc] init];
    }
    return _tParams;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    


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
        [coreDataManager addTransaction:self.tParams
                            withSuccess:^{[self dismissViewControllerAnimated:YES completion:NULL];}
                                failure:^(NSError *error){NSLog(@"error: %@", error.description);}];
    }
}


- (BOOL)checkParams {
    
    NSString *accountKey = [self.tParams valueForKey:kTransactionAccountKey];
    NSString *name = [self.tParams valueForKey:kTransactionName];
    NSNumber *value = [self.tParams valueForKey:kTransactionValue];
    NSNumber *currency = [self.tParams valueForKey:kTransactionCurrency];
    
    return (accountKey.length && name.length && value && currency) ? YES : NO;
}


#pragma mark -
#pragma mark IMCurrenciesListTableViewControllerDelegate protocol implementation

- (void)currenciesListDidSelectCurrency:(NSString *)currencyKey {
    
    [self.tParams setValue:[CurrencyConfig currencyNumberByKey:currencyKey] forKey:kTransactionCurrency];
}


#pragma mark -
#pragma mark UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.nameTextField && textField.text.length) {
        [self.tParams setValue:textField.text forKey:kTransactionName];
    }
    if (textField == self.valueTextField && textField.text.doubleValue) {
        [self.tParams setValue:[NSNumber numberWithDouble:textField.text.doubleValue] forKey:kTransactionValue];
    }
}

@end
