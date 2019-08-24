//
//  SelectorMediaBar.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectorMediaBarDelegate;
@interface SelectorMediaBar : UIView

@property (nonatomic, weak) id<SelectorMediaBarDelegate>delegate;

/**
 背景
 */
@property (nonatomic, strong) UIImageView *backImageView;

/**
 预览按钮
 */
@property (nonatomic, strong) UIButton *previewButton;

/**
 完成/下一步按钮
 */
@property (nonatomic, strong) UIButton *completeButton;

/**
 选中的数量按钮
 */
@property (nonatomic, strong) UIButton *numberButton;

- (void)setSelectedBarCount:(NSInteger)selectedCount;

+ (CGFloat)barHeight;

@end


@protocol SelectorMediaBarDelegate <NSObject>

- (void)previewButtonDidClicked;

- (void)completeButtonDidClicked;

- (void)numberButtonDidClicked;

@end

