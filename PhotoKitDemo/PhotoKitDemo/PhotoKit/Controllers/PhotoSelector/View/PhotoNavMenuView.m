//
//  PhotoNavMenu.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoNavMenuView.h"
#import "PhotoKitManager.h"

@interface PhotoNavMenuView ()<PhotoNavMenuContentViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskBackView;         //黑色
@property (nonatomic, strong) UIView *contentView;          //放置内容的控件
@property (nonatomic, strong) PhotoNavMenuContentView *contentMenuView;      //内容控件

@end

@implementation PhotoNavMenuView

- (instancetype)initWithOringinFrame:(CGFloat)oringinY
                               items:(NSArray *)items
                           superView:(UIView *)superView {
    
    self = [super initWithFrame:superView.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.menuItems = items;

        CGRect curFrame = self.frame;
        curFrame.origin.y = oringinY;
        self.frame = curFrame;
        
        CGFloat maxHeight = 80*5;
        CGSize contentMenuSize = [PhotoNavMenuContentView contentSize:items.count maxHeight:maxHeight];
        self.contentMenuView.frame = CGRectMake(0.0, 0.0, contentMenuSize.width, contentMenuSize.height);
        
        self.backgroundView.frame = self.bounds;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        
        self.maskBackView.frame = self.bounds;
        self.maskBackView.backgroundColor = [UIColor blackColor];
        self.maskBackView.alpha = 0.0;
        [self.backgroundView addSubview:self.maskBackView];
    
        //内容view
        self.contentView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 0.0);
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self.contentView];
        
        CGRect menuContentFrame = self.contentMenuView.frame;
        self.contentMenuView.delegate = self;
        self.contentMenuView.frame = menuContentFrame;
        self.contentMenuView.menuItems = [NSMutableArray arrayWithArray:items];
        [self.contentView addSubview:self.contentMenuView];
        
        [superView addSubview:self];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.maskBackView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMenuItems:(NSArray *)menuItems {
    _menuItems = menuItems;
    
    CGFloat maxHeight = 80*5;
    CGSize contentMenuSize = [PhotoNavMenuContentView contentSize:menuItems.count maxHeight:maxHeight];
    self.contentMenuView.frame = CGRectMake(0.0, 0.0, contentMenuSize.width, contentMenuSize.height);
    self.contentMenuView.menuItems = [NSMutableArray arrayWithArray:menuItems];
}

/**
 显示动画
 */
- (void)show {
    PhotoNavMenuView *popMenuView = self;
    popMenuView.hidden = NO;
    
    self.maskBackView.alpha = 0.f;
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = CGRectGetHeight(self.contentMenuView.frame);
    
    [UIView animateWithDuration:0.20f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = contentFrame;
        self.maskBackView.alpha = 0.4f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {

    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = 0.0;

    [UIView animateWithDuration:0.20f animations:^{
        self.contentView.frame = contentFrame;

        self.maskBackView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

#pragma mark - PhotoNavMenuContentViewDelegate
- (void)navMenuItemDidClicked:(PhotoNavMenuItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedMenuItemDidClicked:)]) {
        [self.delegate selectedMenuItemDidClicked:item];
    }
    [self dismiss];
}

#pragma mark - SETTER/GETTER
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _backgroundView;
}

- (PhotoNavMenuContentView *)contentMenuView {
    if (!_contentMenuView) {
        _contentMenuView = [[PhotoNavMenuContentView alloc] initWithFrame:CGRectZero];
    }
    return _contentMenuView;
}

- (UIView *)maskBackView {
    if (!_maskBackView) {
        _maskBackView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _maskBackView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

@end
