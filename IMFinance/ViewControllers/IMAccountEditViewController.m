//
//  IMAccountEditViewController.m
//  IMFinance
//
//  Created by Igor Mishchenko on 29.01.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMAccountEditViewController.h"

#import "IMAccountTypeConfig.h"

#import "IMCurrecyPickerViewController.h"
#import "CurrencyConfig.h"

@interface IMAccountEditViewController () <UITextFieldDelegate, IMCurrecyPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIPickerView *accountTypePicker;
@property (nonatomic, strong) NSString *currencyCode;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation IMAccountEditViewController

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
    self.currencyCode = [curConfig defaultCurrencyCode];
        
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
    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
            if (!textField.text.length) return;
        }
    }
    NSNumber *accountType = [NSNumber numberWithInteger:[self.accountTypePicker selectedRowInComponent:0]];
        
    PFObject *account = [PFObject objectWithClassName:@"Account"];
    if (![account[@"name"] isEqualToString:self.nameTextField.text])
        [account setObject:self.nameTextField.text forKey:@"name"];
    [account setObject:accountType forKey:@"type"];
    [account saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}


- (void)updateCurrencyButtonTitle {

    NSString *currencyCode = self.currencyCode;
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

    [self setCurrencyCode:currencyCode];
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
