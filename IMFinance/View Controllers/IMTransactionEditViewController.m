//
//  IMTransactionEditViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 07.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMTransactionEditViewController.h"

#import "IMCoreDataManager.h"
#import "Transaction.h"
#import "Account.h"

#import "CurrencyConfig.h"
#import "IMCurrecyPickerViewController.h"

#import "IMAccountSelectorController.h"


static NSString *kTransactionKey = @"transaction key";
static NSString *kTransactionName = @"transaction name";
static NSString *kTransactionValue = @"transaction value";
static NSString *kTransactionCurrency = @"transaction currency";
static NSString *kAccountKey = @"account key";


@interface IMTransactionEditViewController () <IMCurrecyPickerViewControllerDelegate, UITextFieldDelegate, IMAccountSelectorControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation IMTransactionEditViewController

#pragma mark -
#pragma mark - Getters

- (NSDictionary *)params {
    
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}


#pragma mark -
#pragma mark - View Controller's Lifecycle

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
    
    self.nameTextField.delegate = self;
    self.valueTextField.delegate = self;
    
    if (self.transactionKey) {
        Transaction *trans = [Transaction MR_findFirstByAttribute:@"key" withValue:self.transactionKey];
        
        [self.params setValue:trans.key forKey:kTransactionKey];
        [self.params setValue:trans.name forKey:kTransactionName];
        [self.params setValue:trans.value forKey:kTransactionValue];
        [self.currencyButton setTitle:[[[CurrencyConfig alloc] init] currencyNameWithCode:trans.currency] forState:UIControlStateNormal];
        [self.params setValue:trans.currency forKey:kTransactionCurrency];
        [self.params setValue:trans.account.key forKey:kAccountKey];
        
        self.nameTextField.text = trans.name;
        self.valueTextField.text = [NSString stringWithFormat:@"%@", trans.value];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"select currency"]) {
        IMCurrecyPickerViewController *picker = (IMCurrecyPickerViewController *)segue.destinationViewController;
        picker.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"select account"]) {
        IMAccountSelectorController *accountSelector = (IMAccountSelectorController *)segue.destinationViewController;
        accountSelector.delegate = self;
    }
}


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    for (UITextField *textField in self.view.subviews) {
        [textField resignFirstResponder];
    }
    
    if ([self setupParams]) {
        [[IMCoreDataManager sharedInstance] editTransactionWithParams:self.params
                                                              success:^{[self dismissViewControllerAnimated:YES completion:NULL];}
                                                              failure:^(NSError *error){NSLog(@"%@", error.userInfo);}];
    }
    else NSLog(@"заполните все поля!");
}


- (BOOL)setupParams {
    
    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
        }
    }
    
    [self.params setValue:self.nameTextField.text forKey:kTransactionName];
    [self.params setValue:[NSNumber numberWithDouble:self.valueTextField.text.doubleValue] forKey:kTransactionValue];
    
    return YES;
}


#pragma mark -
#pragma mark - UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.valueTextField && [textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.valueTextField && !textField.text.length) {
        textField.text = @"0";
    }
    return YES;
}


#pragma mark -
#pragma mark - IMCurrecyPickerViewControllerDelegate protocol implementation

- (void)pickerDidSelectCurrency:(NSString *)currencyCode {
    
    [self.params setValue:currencyCode forKey:kTransactionCurrency];
    NSString *currencyName = [[[CurrencyConfig alloc] init] currencyNameWithCode:currencyCode];
    [self.currencyButton setTitle:currencyName forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - IMAccountSelectorControllerDelegate protocol implementation

- (void)selectorDidSelectAccount:(Account *)account {

    [self.params setValue:account.key forKey:kAccountKey];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
