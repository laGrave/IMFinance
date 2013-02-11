//
//  IMSwipedTableViewCell.m
//  IMFinance
//
//  Created by Igor Mishchenko on 11.02.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import "IMSwipedTableViewCell.h"

@implementation IMSwipedTableViewCell

@synthesize cellBackgroundView = _cellBackgroundView;

- (UIView *)cellBackgroundView {

    if (!_cellBackgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor redColor];
        [self setBackgroundView:backgroundView];
    }
    return _cellBackgroundView;
}


- (void)setCellBackgroundView:(UIView *)cellBackgroundView {

    if (_cellBackgroundView) {
        [_cellBackgroundView removeFromSuperview];
        _cellBackgroundView = nil;
    }
    
    if (self.superview) {
        cellBackgroundView.frame = self.frame;
        [self.superview insertSubview:cellBackgroundView belowSubview:self];
        _cellBackgroundView = cellBackgroundView;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
}


#pragma mark -
#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesBegan:inCell:)]) {
        [self.delegate touchesBegan:touches inCell:self];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesMoved:inCell:)]) {
        [self.delegate touchesMoved:touches inCell:self];
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    
    CGFloat deltaX = location.x - previousLocation.x;
    
    CGRect cellFrame = self.frame;
    cellFrame.origin.x += deltaX;
    self.frame = cellFrame;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesEnded:inCell:)]) {
        [self.delegate touchesEnded:touches inCell:self];
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = self.backgroundView.frame;
    }];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesCancelled:inCell:)]) {
        [self.delegate touchesCancelled:touches inCell:self];
    }
    [self touchesEnded:touches withEvent:event];
}

@end
