//
//  IMCategoryEditViewController.m
//  IMFinance
//
//  Created by Игорь Мищенко on 24.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoryEditViewController.h"

#import "Category.h"

#import "IMCoreDataManager.h"

static NSString *kCategory = @"category";
static NSString *kCategoryKey = @"category key";
static NSString *kCategoryName = @"categoryName";
static NSString *kCategoryOrder = @"categoryOrder";
static NSString *kCategoryIcon = @"categoryIconName";
static NSString *kCategoryIncomeType = @"categoryIncomeType";
//static NSString *kCategoryParent = @"categoryParent";

@interface IMCategoryEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *params;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
#pragma mark - View Controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.nameTextField.delegate = self;
    
    if (self.category) {
        Category *c = [self.category MR_inThreadContext];
        [self.params setValue:c forKey:kCategory];
        [self.params setValue:c.key forKey:kCategoryKey];
        [self.params setValue:c.name forKey:kCategoryName];
        [self.params setValue:c.order forKey:kCategoryOrder];
        [self.params setValue:c.incomeType forKey:kCategoryIncomeType];
        
        [self.nameTextField setText:NSLocalizedString(c.name, @"")];
        NSInteger selectedIndex = (c.incomeType.boolValue) ? 1 : 0;
        [self.segmentedControl setSelectedSegmentIndex:selectedIndex];
        
        [self setCategory:nil];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance methods

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.nameTextField.text.length) {
        NSString *localizedName = NSLocalizedString([self.params objectForKey:kCategoryName], @"");
        if (![localizedName isEqualToString:self.nameTextField.text]) {
            [self.params setValue:self.nameTextField.text forKey:kCategoryName];
        }
        
        BOOL incomeType = NO;
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 1:
                incomeType =  YES;
                break;
            default:
                incomeType = NO;
                break;
        }
        
        NSNumber *type = [NSNumber numberWithBool:incomeType];

        if (incomeType != [[self.params valueForKey:kCategoryIncomeType] boolValue])
            [self.params removeObjectForKey:kCategoryOrder];
        
        [self.params setValue:type forKey:kCategoryIncomeType];

        [[IMCoreDataManager sharedInstance] editCategoryWithParams:self.params];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание"
                                                        message:@"Пожалуйста, введите название категории."
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate protocol implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
