//
//  SelectorMarkView.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectorMarkViewDelegate;

@interface SelectorMarkView : UIView

@property (nonatomic, weak) id<SelectorMarkViewDelegate>delegate;

/**
 选中的标记图片
 */
@property (nonatomic, strong) UIButton *selectedImageView;

/**
 选中时的是否需要动画
 */
@property (nonatomic, assign) BOOL animated;

/**
 按钮是否是selected
 */
@property (nonatomic, assign) BOOL selected;

/**
 设置选中状态

 @param selected 选中
 @param animated 动画
 */
- (void)setMarkSelected:(BOOL)selected animated:(BOOL)animated;

@end

@protocol SelectorMarkViewDelegate <NSObject>

- (void)selectorMarkDidClicked:(SelectorMarkView *)view;

@end
