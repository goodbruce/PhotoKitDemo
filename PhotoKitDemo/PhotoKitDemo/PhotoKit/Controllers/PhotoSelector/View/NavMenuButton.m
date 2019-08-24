//
//  NavMenuButton.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "NavMenuButton.h"
#import "NavMenuContext.h"
#import "PhotoKitViewUtils.h"

@interface NavMenuButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation NavMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        frame.origin.y -= 2.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;

        self.titleLabel.textColor = [NavMenuContext mainColor];
        [self addSubview:self.titleLabel];
        
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.arrow.image = [NavMenuContext arrowImage];
        self.arrow.bounds = CGRectMake(0.0, 0.0, 14.0, 8.0);
        [self addSubview:self.arrow];
    }
    return self;
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat height = CGRectGetHeight(bounds) - 2.0;
    self.titleLabel.center = CGPointMake(CGRectGetWidth(bounds) / 2, height / 2);
    
    CGSize titleSize = [PhotoKitViewUtils sizeWithFont:[UIFont systemFontOfSize:20.0] forMaxSize:CGSizeMake(CGRectGetWidth(bounds), height) contentText:self.titleLabel.text];
    
    self.titleLabel.bounds = CGRectMake(0.0, 0.0, titleSize.width, titleSize.height);
    
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + [NavMenuContext arrowPadding], self.frame.size.height / 2);
    self.arrow.bounds = CGRectMake(0.0, 0.0, 14.0, 8.0);
}

#pragma mark -
#pragma mark Handle taps
- (void)setActive:(BOOL)active
{
    _active = active;
    if (self.isActive) {
        [self rotateArrow:M_PI];
    } else {
        [self rotateArrow:0];
    }
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:[NavMenuContext animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

@end
