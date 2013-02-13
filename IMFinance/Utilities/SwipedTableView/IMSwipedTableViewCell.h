//
//  IMSwipedTableViewCell.h
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMSwipedTableViewCell;

@protocol IMSwipedTableViewCellDelegate <NSObject>

- (void)touchesBegan:(NSSet *)touches inCell:(IMSwipedTableViewCell *)cell;
- (void)touchesMoved:(NSSet *)touches inCell:(IMSwipedTableViewCell *)cell;
- (void)touchesEnded:(NSSet *)touches inCell:(IMSwipedTableViewCell *)cell;
- (void)touchesCancelled:(NSSet *)touches inCell:(IMSwipedTableViewCell *)cell;

@end

@interface IMSwipedTableViewCell : UITableViewCell

@property (nonatomic, weak) id <IMSwipedTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIView *cellContentView;

@end
