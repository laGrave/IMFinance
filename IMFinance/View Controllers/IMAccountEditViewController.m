//
//  IMAccountEditViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMAccountEditViewController.h"

#import "IMCoreDataManager.h"
#import "Account.h"

#import "IMAccountTypeConfig.h"

#import "IMCurrecyPickerViewController.h"
#import "CurrencyConfig.h"

static NSString *kAccountKey = @"account key";
static NSString *kAccountName = @"account name";
static NSString *kAccountInitialValue = @"account initial value";
static NSString *kAccountCurrency = @"account currency";
static NSString *kAccountType = @"account type";

@interface IMAccountEditViewController () <UITextFieldDelegate, IMCurrecyPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIPickerView *accountTypePicker;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation IMAccountEditViewController


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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.nameTextField.delegate = self;
    self.valueTextField.delegate = self;
    self.accountTypePicker.dataSource = self;
    self.accountTypePicker.delegate = self;
    [self.accountTypePicker reloadAllComponents];
    
    CurrencyConfig *curConfig = [[CurrencyConfig alloc] init];
    
    if (self.accountKey) {
        Account *account = [Account MR_findFirstByAttribute:@"key" withValue:self.accountKey];
        
        [self.params setValue:account.key forKey:kAccountKey];
        [self.params setValue:account.name forKey:kAccountName];
        [self.params setValue:account.type forKey:kAccountType];
        [self.accountTypePicker selectRow:account.type.integerValue inComponent:0 animated:NO];
        
        NSString *currency = account.currency;
        if (currency && currency.length) {
            [self.currencyButton setTitle:[curConfig currencyNameWithCode:currency] forState:UIControlStateNormal];
            [self.params setValue:account.currency forKey:kAccountCurrency];
        }
        
        
        self.nameTextField.text = account.name;
    }
    
    else [self.params setValue:[curConfig defaultCurrencyCode] forKey:kAccountCurrency];
    
    [self updateCurrencyButtonTitle];
    
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
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    for (UITextField *textField in self.view.subviews) {
        [textField resignFirstResponder];
    }
    
    if ([self setupParams]) {
        [[IMCoreDataManager sharedInstance] editAccountWithParams:self.params
                                                          success:^{[self dismissViewControllerAnimated:YES completion:NULL];}
                                                          failure:^(NSError *error){;}];
    }
    else NSLog(@"заполните все поля!");
}


- (BOOL)setupParams {
    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
            if (!textField.text.length) return NO;
        }
    }
    
    [self.params setValue:self.nameTextField.text forKey:kAccountName];
    [self.params setValue:[NSNumber numberWithDouble:self.valueTextField.text.doubleValue] forKey:kAccountInitialValue];
    NSNumber *accountType = [NSNumber numberWithInteger:[self.accountTypePicker selectedRowInComponent:0]];
    [self.params setValue:accountType forKey:kAccountType];
    
    return YES;
}


- (void)updateCurrencyButtonTitle {

    NSString *currencyCode = [self.params objectForKey:kAccountCurrency];
    NSString *currencyName = [[[CurrencyConfig alloc] init] currencyNameWithCode:currencyCode];
    [self.currencyButton setTitle:currencyName forState:UIControlStateNormal];
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

    [self.params setValue:currencyCode forKey:kAccountCurrency];
    [self updateCurrencyButtonTitle];
}


#pragma mark -
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [[IMAccountTypeConfig typeList] count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [[IMAccountTypeConfig localizedTypeList] objectAtIndex:row];
}

@end
