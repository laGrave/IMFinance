//
//  IMCategoriesConfig.m
//  IMFinance
//
//  Created by Игорь Мищенко on 22.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMCategoriesConfig.h"

#import "Category.h"

#import "IMCoreDataManager.h"


@implementation IMCategoriesConfig

+ (void)setupBaseCategories {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BaseCatogories" ofType:@"plist"];
    NSArray *categories = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *categoryParams in categories) {
        [self setCategoryWithParameters:categoryParams];
    }
}

+ (void)setCategoryWithParameters:(NSDictionary *)categoryDict {

    IMCoreDataManager *coreDataManager = [[IMCoreDataManager alloc] init];
    [coreDataManager editTransactionWithParams:categoryDict success:^{;} failure:^{;}];
    NSArray *values = [categoryDict allValues];
    for (id value in values) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self setCategoryWithParameters:value];
        }
    }
}

@end
