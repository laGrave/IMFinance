//
//  IMCategoryEditViewController.h
//  IMFinance
//
//  Created by Игорь Мищенко on 24.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@interface IMCategoryEditViewController : UIViewController

@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) NSString *objectId;

@end
