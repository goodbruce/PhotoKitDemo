//
//  PhotoKitViewUtils.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoKitDefine.h"

@interface PhotoKitViewUtils : NSObject

/**
 获取安全区域
 
 @return 安全区域
 */
+ (UIEdgeInsets)baseSafeAreaEdgeInsets;

/**
 计算字符串的Size
 
 @param font 字体大小
 @param maxSize 最大范围的Size
 @param contentText 字符串
 @return 计算后的size
 */
+ (CGSize)sizeWithFont:(UIFont *)font forMaxSize:(CGSize)maxSize contentText:(NSString *)contentText;


/**
 设置选中时候的动画效果
 
 @param view 控件
 */
+ (void)setUpCheckedAnimation:(UIView *)view;

/**
 预览图所用尺寸
 
 @param picWidth 图片宽
 @param picHeight 图片高
 @return 新尺寸
 */
+ (CGSize)getImageShowSizewithWidth:(float)picWidth Height:(float)picHeight;

@end
