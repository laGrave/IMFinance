//
//  IMTransactionCell.h
//  IMFinance
//
//  Created by Igor Mishchenko on 25.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
