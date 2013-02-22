//
//  IMCategoriesPickerViewController.h
//  IMFinance
//
//  Created by Игорь Мищенко on 22.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@protocol  IMCategoriesPickerDelegate <NSObject>

- (void)categoriesPickerDidSelectCategory:(Category *)category;

@end

@interface IMCategoriesPickerViewController : UITableViewController

@property (nonatomic, weak) id <IMCategoriesPickerDelegate> delegate;

@end
