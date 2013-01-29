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

static NSString *kAccountKey = @"account key";
static NSString *kAccountName = @"account name";
static NSString *kAccountValue = @"account value";
static NSString *kAcccountCurrency = @"account currency";

@interface IMAccountEditViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

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
    
    if (self.accountKey) {
        Account *account = [Account MR_findFirstByAttribute:@"key" withValue:self.accountKey];
        
        [self.params setValue:account.key forKey:kAccountKey];
        [self.params setValue:account.name forKey:kAccountName];
        [self.params setValue:account.value forKey:kAccountValue];
        [self.params setValue:account.currency forKey:kAcccountCurrency];
        
        
        self.nameTextField.text = account.name;
        self.valueTextField.text = [NSString stringWithFormat:@"%@", account.value];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    for (UITextField *textField in self.view.subviews) {
        [textField resignFirstResponder];
    }
    
    if ([self setupParams]) {
        [[IMCoreDataManager sharedInstance] editAccountInBackground:self.params
                                                        withSuccess:^{[self dismissViewControllerAnimated:YES completion:NULL];}
                                                            failure:^(NSError *error){NSLog(@"%@", error.localizedDescription);}];
    }
    else NSLog(@"заполните все поля!");
}


- (BOOL)setupParams {

    
    for (UITextField *textField in self.view.subviews) {
        [textField resignFirstResponder];
        if (!textField.text.length) return NO;
    }
    
    [self.params setValue:self.nameTextField.text forKey:kAccountName];
    [self.params setValue:[NSNumber numberWithDouble:self.valueTextField.text.doubleValue] forKey:kAccountValue];
    
    return YES;
}



#pragma mark -
#pragma mark - UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (textField == self.valueTextField && !textField.text.length) {
        textField.text = @"0";
    }
    return YES;
}

@end
