//
//  IMCategoryEditViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 24.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoryEditViewController.h"

#import "Category.h"

static NSString *kCategoryKey = @"category key";
static NSString *kCategoryName = @"categoryName";
static NSString *kCategoryOrder = @"categoryOrder";
static NSString *kCategoryIcon = @"categoryIconName";
static NSString *kCategoryIncomeType = @"categoryIncomeType";
//static NSString *kCategoryParent = @"categoryParent";

@interface IMCategoryEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation IMCategoryEditViewController

#pragma mark -
#pragma mark - Getters

- (NSMutableDictionary *)params {

    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
        
        [_params setValue:[NSNumber numberWithBool:NO] forKey:kCategoryIncomeType];
    }
    return _params;
}


#pragma mark -
#pragma mark - Setters

- (void)setCategory:(Category *)category {

    [self.params setValue:category.key forKey:kCategoryKey];
    [self.params setValue:category.name forKey:kCategoryName];
    [self.params setValue:category.order forKey:kCategoryOrder];
    [self.params setValue:category.incomeType forKey:kCategoryIncomeType];
}


#pragma mark -
#pragma mark - View Controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance methods

- (void)setupParams {

//    [self.params setValue:<#(id)#> forKey:<#(NSString *)#>]
}


#pragma mark -
#pragma mark - UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (!textField.text.length) {
        textField.text = @"0";
    }
    return YES;
}

@end
