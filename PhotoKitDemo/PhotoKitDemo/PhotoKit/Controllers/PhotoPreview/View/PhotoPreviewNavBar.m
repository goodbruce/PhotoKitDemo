//
//  PhotoPreviewNavBar.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoPreviewNavBar.h"

@interface PhotoPreviewNavBar ()

@end

@implementation PhotoPreviewNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        _needsAnimated = YES;
        
        _backButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitle:@"取消" forState:UIControlStateDisabled];
        [_backButton addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _selectButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _selectButton.backgroundColor = [UIColor clearColor];
        _selectButton.userInteractionEnabled = YES;
        [_selectButton setImage:[UIImage imageNamed:@"ic_image_uncheck"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"ic_image_check"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(handleSelectAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_selectButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect backRect = CGRectMake(20.0, CGRectGetHeight(bounds) - 44.0, 48.0, 44.0);
    self.backButton.frame = backRect;
    self.selectButton.bounds = self.backButton.bounds;
    self.selectButton.center = CGPointMake(CGRectGetMaxX(bounds) - self.backButton.center.x, self.backButton.center.y);
}

- (void)setCurrentSelected:(BOOL)isSelected animated:(BOOL)animated {
    self.selectButton.selected = isSelected;
    if (animated) {
        [self setUpAnimation];
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
    [self.selectButton.layer addAnimation:animationGroup forKey:@"bounce"];
}

- (void)handleBackAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate performSelector:@selector(back)];
    }
}

- (void)handleSelectAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSelectDidClicked)]) {
        [self.delegate handleSelectDidClicked];
    }
}

@end
