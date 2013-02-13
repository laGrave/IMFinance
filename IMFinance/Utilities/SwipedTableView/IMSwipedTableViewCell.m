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
@synthesize cellContentView = _cellContentView;

- (UIView *)cellContentView {

    if (!_cellContentView) {
        UIView *contenView = [[UIView alloc] initWithFrame:self.bounds];
        contenView.backgroundColor = [UIColor blueColor];
        [self setCellContentView:contenView];
    }
    return _cellContentView;
}


- (void)setCellContentView:(UIView *)cellContentView {

    if (_cellContentView) {
        [_cellContentView removeFromSuperview];
        _cellContentView = nil;
    }
    
    if (self.superview) {
        cellContentView.frame = self.bounds;
        [self addSubview:cellContentView];
        _cellContentView = cellContentView;
    }
}


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
        cellBackgroundView.frame = self.bounds;
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
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panRecognizer];
}


- (void)pan:(UIPanGestureRecognizer *)recognizer {

//    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
//        <#statements#>
//    }
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
    
    CGRect cellFrame = self.cellContentView.frame;
    cellFrame.origin.x += deltaX;
    self.cellContentView.frame = cellFrame;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesEnded:inCell:)]) {
        [self.delegate touchesEnded:touches inCell:self];
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.cellContentView.frame = self.bounds;
    }];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([self.delegate respondsToSelector:@selector(touchesCancelled:inCell:)]) {
        [self.delegate touchesCancelled:touches inCell:self];
    }
    [self touchesEnded:touches withEvent:event];
}

@end
