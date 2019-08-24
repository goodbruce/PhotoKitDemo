//
//  SelectorMarkView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "SelectorMarkView.h"

@implementation SelectorMarkView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        _selectedImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedImageView.userInteractionEnabled = YES;
        _selectedImageView.backgroundColor = [UIColor clearColor];
        _selectedImageView.clipsToBounds = YES;
        [_selectedImageView setImage:[UIImage imageNamed:@"ic_image_check"] forState:UIControlStateSelected];
        [_selectedImageView setImage:[UIImage imageNamed:@"ic_image_uncheck"] forState:UIControlStateNormal];
        [_selectedImageView addTarget:self action:@selector(selectorMarkClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectedImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(bounds)/2, CGRectGetHeight(bounds)/2);
    CGSize size = CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    self.selectedImageView.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
    self.selectedImageView.center = center;
}

/**
 设置选中状态
 
 @param selected 选中
 @param animated 动画
 */
- (void)setMarkSelected:(BOOL)selected animated:(BOOL)animated {
    _selected = selected;

    self.animated = animated;
    [self.selectedImageView.layer removeAnimationForKey:@"bounce"];
    if (selected) {
        self.selectedImageView.selected = YES;
        if (self.animated) {
            [self setUpAnimation];
            self.animated = NO;
        }
    } else {
        self.selectedImageView.selected = NO;
    }
}

- (void)selectorMarkClicked {
    if (self.animated) {
        [self setUpAnimation];
    }
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorMarkDidClicked:)]) {
        [self.delegate selectorMarkDidClicked:self];
    }
}

- (void)setUpAnimation {
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.0;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation1.fromValue = @0.0;
    scaleAnimation1.toValue = @1.2;
    scaleAnimation1.duration = 0.4;
    scaleAnimation1.beginTime = 0.0;
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation2.fromValue = @1.2;
    scaleAnimation2.toValue = @0.9;
    scaleAnimation2.duration = 0.2;
    scaleAnimation2.beginTime = 0.4;
    
    CABasicAnimation *scaleAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation3.fromValue = @0.9;
    scaleAnimation3.toValue = @1.1;
    scaleAnimation3.duration = 0.2;
    scaleAnimation3.beginTime = 0.6;
    
    CABasicAnimation *scaleAnimation4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation4.fromValue = @1.1;
    scaleAnimation4.toValue = @1.0;
    scaleAnimation4.duration = 0.2;
    scaleAnimation4.beginTime = 0.8;
    
    NSArray *animations = @[scaleAnimation1, scaleAnimation2, scaleAnimation3, scaleAnimation4];
    animationGroup.animations = animations;
    [self.selectedImageView.layer addAnimation:animationGroup forKey:@"bounce"];
}

@end

