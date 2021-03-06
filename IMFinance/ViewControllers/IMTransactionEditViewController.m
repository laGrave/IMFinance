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
#import "Category.h"

#import "CurrencyConfig.h"
#import "IMCurrecyPickerViewController.h"

#import "IMAccountSelectorController.h"

#import "IMCategoriesPickerViewController.h"

#import "IMDateStartPicker.h"


static NSString *kTramsaction = @"transaction";
static NSString *kTransactionName = @"transaction name";
static NSString *kTransactionIncomeType = @"transaction income type";
static NSString *kTransactionValue = @"transaction value";
static NSString *kTransactionFee = @"transaction fee";
static NSString *kTransactionCurrency = @"transaction currency";
static NSString *kTransactionStartDate = @"transaction start date";
static NSString *kTransactionCategory = @"transaction category";
static NSString *kAccount = @"account";


@interface IMTransactionEditViewController () <IMCurrecyPickerViewControllerDelegate, UITextFieldDelegate, IMAccountSelectorControllerDelegate, IMDateStartPickerDelegate, UIActionSheetDelegate, IMCategoriesPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UITextField *feeTextField;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *incomeTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

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
    
    CurrencyConfig *curConfig = [[CurrencyConfig alloc] init];
    
    if (self.transaction) {
        Transaction *trans = [self.transaction MR_inThreadContext];
        self.nameTextField.text = trans.name;
        self.valueTextField.text = [NSString stringWithFormat:@"%@", trans.value];
        if ([trans.fee doubleValue] != 0) {
            self.feeTextField.text = [NSString stringWithFormat:@"%@", trans.fee];
        }
        
        [self.params setValue:trans forKey:kTramsaction];
        [self.params setValue:trans.name forKey:kTransactionName];
        [self.params setValue:trans.incomeType forKey:kTransactionIncomeType];
        [self.params setValue:trans.value forKey:kTransactionValue];
        [self.params setValue:trans.fee forKey:kTransactionFee];
        [self.params setValue:trans.currency forKey:kTransactionCurrency];
        [self.params setValue:trans.account forKey:kAccount];
        [self.params setValue:trans.startDate forKey:kTransactionStartDate];
        [self.params setValue:trans.category forKey:kTransactionCategory];
    }
    else if (self.account) {
        Account *account = [self.account MR_inThreadContext];
        [self.accountButton setTitle:account.name forState:UIControlStateNormal];
        
        [self.params setValue:account forKey:kAccount];
        [self.params setValue:account.currency forKey:kTransactionCurrency];
        [self.params setValue:[NSDate date] forKey:kTransactionStartDate];
        [self.params setValue:[NSNumber numberWithBool:0] forKey:kTransactionIncomeType];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"incomeType == %@", [self.params objectForKey:kTransactionIncomeType]];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"system == NO"];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
        [self.params setValue:[Category MR_findFirstWithPredicate:predicate sortedBy:@"order" ascending:YES] forKey:kTransactionCategory];
    }
    else {
        [self.params setValue:[NSNumber numberWithBool:0] forKey:kTransactionIncomeType];
        [self.params setValue:[curConfig defaultCurrencyCode] forKey:kTransactionCurrency];
        [self.params setValue:[NSDate date] forKey:kTransactionStartDate];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"incomeType == %@", [self.params objectForKey:kTransactionIncomeType]];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"system == NO"];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
        [self.params setValue:[Category MR_findFirstWithPredicate:predicate sortedBy:@"order" ascending:YES] forKey:kTransactionCategory];
    }
    [self updateIncomeTypeButtonTitle];
    [self updateCurrencyButtonTitle];
    [self updateStartDateButtonTitle];
    [self updateCategoryButtonTitle];
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
                                                              failure:^(NSError *error){
                                                                  NSLog(@"%@", error.userInfo);
                                                                  [self dismissViewControllerAnimated:YES completion:NULL];
                                                              }];
    }
    else NSLog(@"заполните все поля!");
}

- (IBAction)startDateButtonPressed:(UIButton *)sender {
    
    IMDateStartPicker *startDatePicker = [[IMDateStartPicker alloc] initWithDate:[self.params valueForKey:kTransactionStartDate]
                                                                        delegate:self];
    __block CGRect rect = startDatePicker.frame;
    rect.origin.y = self.view.bounds.size.height;
    startDatePicker.frame = rect;
    [self.view addSubview:startDatePicker];
    [UIView animateWithDuration:0.4
                     animations:^{
                         rect.origin.y -= rect.size.height;
                         startDatePicker.frame = rect;
                     }];
}



- (IBAction)incomeTypeButtonPressed:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Расход", @"Доход", nil];
    [actionSheet showInView:self.view];
}


- (IBAction)categoryButtonPressed:(UIButton *)sender {
    
    IMCategoriesPickerViewController *categoryPicker = [[IMCategoriesPickerViewController alloc] initWithIncomeType:[self.params objectForKey:kTransactionIncomeType] delegate:self];
    [self.navigationController pushViewController:categoryPicker animated:YES];
}


- (BOOL)setupParams {
    
    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
        }
    }
    
    if (![self.params objectForKey:kAccount]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Не выбран счет"
                                                        message:@"Пожалуйста, выберите счет"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", NULL)
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    [self.params setValue:self.nameTextField.text forKey:kTransactionName];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [self.params setValue:[formatter numberFromString:self.valueTextField.text] forKey:kTransactionValue];
    
    if ([self.feeTextField.text length]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
        
        [self.params setValue:[formatter numberFromString:self.feeTextField.text] forKey:kTransactionFee];
    }
    else [self.params setValue:[NSNumber numberWithDouble:0] forKey:kTransactionFee];
    
    return YES;
}


- (void)updateStartDateButtonTitle {

    NSString *stringDate = [NSDateFormatter localizedStringFromDate:[self.params objectForKey:kTransactionStartDate]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    [self.startDateButton setTitle:stringDate forState:UIControlStateNormal];
}


- (void)updateCurrencyButtonTitle {

    NSString *currencyCode = [self.params objectForKey:kTransactionCurrency];
    NSString *currencyName = [[[CurrencyConfig alloc] init] currencyNameWithCode:currencyCode];
    [self.currencyButton setTitle:currencyName forState:UIControlStateNormal];
}


- (void)updateIncomeTypeButtonTitle {

    BOOL income = [[self.params objectForKey:kTransactionIncomeType] boolValue];
    NSString *incomeType = (income) ? @"Доход" : @"Расход";
    [self.incomeTypeButton setTitle:incomeType forState:UIControlStateNormal];
}


- (void)updateCategoryButtonTitle {

    Category *category = [self.params objectForKey:kTransactionCategory];
    NSString *categoryName = NSLocalizedString(category.name, @"");
    [self.categoryButton setTitle:categoryName forState:UIControlStateNormal];
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
    if (textField == self.feeTextField && [textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    return YES;
}


#pragma mark -
#pragma mark - IMCurrecyPickerViewControllerDelegate protocol implementation

- (void)pickerDidSelectCurrency:(NSString *)currencyCode {
    
    [self.params setValue:currencyCode forKey:kTransactionCurrency];
    [self updateCurrencyButtonTitle];
}


#pragma mark -
#pragma mark - IMAccountSelectorControllerDelegate protocol implementation

- (void)selectorDidSelectAccount:(Account *)anAccount {

    Account *account = [anAccount MR_inThreadContext];
    [self.params setValue:account forKey:kAccount];
    [self.params setValue:account.currency forKey:kTransactionCurrency];
    [self.accountButton setTitle:account.name forState:UIControlStateNormal];
    [self updateCurrencyButtonTitle];
}


#pragma mark -
#pragma mark - IMDateStartPickerDelegate protocol implementation

- (void)startDatePickerDidSelectDate:(NSDate *)startDate {

    [self.params setValue:startDate forKey:kTransactionStartDate];
    [self updateStartDateButtonTitle];
}

- (void)startDatePickerShouldDismiss:(IMDateStartPicker *)picker {

    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect rect = picker.frame;
                         rect.origin.y = self.view.bounds.size.height;
                         picker.frame = rect;
                     }
                     completion:^(BOOL finished){
                         [picker removeFromSuperview];
                     }];
}


#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self.params setValue:[NSNumber numberWithBool:0] forKey:kTransactionIncomeType];
    }
    else [self.params setValue:[NSNumber numberWithBool:1] forKey:kTransactionIncomeType];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"incomeType == %@", [self.params objectForKey:kTransactionIncomeType]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"system == NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
    [self.params setValue:[Category MR_findFirstWithPredicate:predicate sortedBy:@"order" ascending:YES] forKey:kTransactionCategory];

    [self updateIncomeTypeButtonTitle];
    [self updateCategoryButtonTitle];
}


#pragma mark -
#pragma mark - IMCategoriesPickerDelegate

- (void)categoriesPickerDidSelectCategory:(Category *)category {

    [self.params setValue:category forKey:kTransactionCategory];
    [self updateCategoryButtonTitle];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
