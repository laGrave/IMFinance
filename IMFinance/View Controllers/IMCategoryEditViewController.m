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
#pragma mark - Setters

- (void)setCategory:(Category *)category {

    [self.params setValue:category.key forKey:kCategoryKey];
    [self.params setValue:category.name forKey:kCategoryName];
    [self.params setValue:category.order forKey:kCategoryOrder];
    [self.params setValue:category.incomeType forKey:kCategoryIncomeType];
    
    [self.nameTextField setText:NSLocalizedString(category.name, @"")];
    NSInteger selectedIndex = (category.incomeType.boolValue) ? 1 : 0;
    [self.segmentedControl setSelectedSegmentIndex:selectedIndex];
}


#pragma mark -
#pragma mark - View Controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.nameTextField.delegate = self;
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
        
        [self.params setValue:[NSNumber numberWithBool:incomeType] forKey:kCategoryIncomeType];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"incomeType == %@", [self.params objectForKey:kCategoryIncomeType]];
        NSNumber *order = [Category MR_numberOfEntitiesWithPredicate:predicate];
        [self.params setValue:order forKey:kCategoryOrder];
        
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
