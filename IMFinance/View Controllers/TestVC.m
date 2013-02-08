//
//  TestVC.m
//  IMFinance
//
//  Created by Igor Mishchenko on 08.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "TestVC.h"

#import "IMDatePickerView.h"

@interface TestVC () <IMDatePickerViewDelegate>

@end

@implementation TestVC

static NSString *kDateStart = @"start date";
static NSString *kDateInterval = @"date interval";
static NSString *kDateEnd = @"end date";

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
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSDate date], kDateStart, [NSNumber numberWithInteger:14], kDateInterval, nil];
    
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"IMDatePickerView" owner:nil options:nil];
//    IMDatePickerView *view = [views objectAtIndex:0];
    IMDatePickerView *view = [[IMDatePickerView alloc] initWithParams:params delegate:self];
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePicker:(IMDatePickerView *)picker didSelectDateParameters:(NSDictionary *)params {

    [picker removeFromSuperview];
}

@end
