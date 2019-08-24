//
//  SelectorMediaBar.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "SelectorMediaBar.h"
#import "PhotoKitViewUtils.h"

static CGFloat kButtonWidth = 50.0;
static CGFloat kToolBarHeigth = 50.0;

static CGFloat kNumberButtonWidth = 26.0;
static CGFloat kNormalPadding = 10.0;

@interface SelectorMediaBar ()

@end


@implementation SelectorMediaBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backImageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.backImageView.clipsToBounds = YES;
        self.backImageView.userInteractionEnabled = YES;
        [self addSubview:self.backImageView];
        
        UIColor *selectedTitleColor = [UIColor colorWithRed:59.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        UIColor *titleColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
        
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
        self.previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.previewButton setTitleColor:titleColor forState:UIControlStateDisabled];
        [self.previewButton addTarget:self action:@selector(previewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.previewButton.enabled = NO;
        [self.backImageView addSubview:self.previewButton];
        
        self.numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.numberButton setTitle:@"" forState:UIControlStateNormal];
        self.numberButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.numberButton addTarget:self action:@selector(numberButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:self.numberButton];
        
        self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.completeButton setTitle:@"下一步" forState:UIControlStateNormal];
        self.completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.completeButton setTitleColor:titleColor forState:UIControlStateNormal];
        [self.completeButton setTitleColor:selectedTitleColor forState:UIControlStateSelected];
        [self.completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:self.completeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImageView.frame = self.bounds;
    self.previewButton.frame = CGRectMake(0.0, 0.0, kButtonWidth, kToolBarHeigth);
    
    NSString *title = [self.completeButton titleForState:UIControlStateNormal];
    
    CGSize titleSize = [PhotoKitViewUtils sizeWithFont:self.completeButton.titleLabel.font forMaxSize:CGSizeMake(CGRectGetWidth(self.backImageView.frame), kToolBarHeigth) contentText:title];
    
    self.completeButton.frame = CGRectMake(CGRectGetWidth(self.backImageView.frame)-titleSize.width - kNormalPadding, 0.0, titleSize.width, kToolBarHeigth);
    
    self.numberButton.frame = CGRectMake(CGRectGetMinX(self.completeButton.frame)-kNumberButtonWidth - kNormalPadding, (kToolBarHeigth - kNumberButtonWidth)/2, kNumberButtonWidth, kNumberButtonWidth);
    self.numberButton.layer.cornerRadius = kNumberButtonWidth/2.0;
    self.numberButton.layer.masksToBounds = YES;
}

- (void)previewButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewButtonDidClicked)]) {
        [self.delegate previewButtonDidClicked];
    }
}

- (void)completeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeButtonDidClicked)]) {
        [self.delegate completeButtonDidClicked];
    }
}

- (void)numberButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberButtonDidClicked)]) {
        [self.delegate numberButtonDidClicked];
    }
}

- (void)setSelectedBarCount:(NSInteger)selectedCount {
    if (selectedCount > 0) {
        self.previewButton.enabled = YES;
        self.completeButton.selected = YES;
        [self.numberButton setTitle:[NSString stringWithFormat:@"%ld",selectedCount] forState:UIControlStateNormal];
        self.numberButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
    } else {
        self.previewButton.enabled = NO;
        self.completeButton.selected = NO;
        [self.numberButton setTitle:@"" forState:UIControlStateNormal];
        self.numberButton.backgroundColor = [UIColor clearColor];
    }
}


+ (CGFloat)barHeight {
    return kToolBarHeigth + [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom;
}

@end
