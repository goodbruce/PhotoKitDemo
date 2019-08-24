//
//  PhotoKitViewUtils.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoKitViewUtils.h"

@implementation PhotoKitViewUtils

/**
 获取安全区域
 
 @return 安全区域
 */
+ (UIEdgeInsets)baseSafeAreaEdgeInsets {
    UIEdgeInsets aSafeEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        aSafeEdgeInsets = safeInsets;
    } else {
        // Fallback on earlier versions
    }
    return aSafeEdgeInsets;
}

/**
 计算字符串的Size

 @param font 字体大小
 @param maxSize 最大范围的Size
 @param contentText 字符串
 @return 计算后的size
 */
+ (CGSize)sizeWithFont:(UIFont *)font forMaxSize:(CGSize)maxSize contentText:(NSString *)contentText {
    if (contentText && contentText.length == 0) {
        return CGSizeMake(0.0, 0.0);
    }
    
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentText];
    NSRange allRange = [contentText rangeOfString:contentText];
    
    NSDictionary *attribute = @{NSFontAttributeName : font};
    
    [attributedStr setAttributes:attribute range:allRange];
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGSize textSize = [attributedStr boundingRectWithSize:maxSize options:options context:nil].size;
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 设置选中时候的动画效果

 @param view 控件
 */
+ (void)setUpCheckedAnimation:(UIView *)view {
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
    [view.layer addAnimation:animationGroup forKey:@"bounce"];
}

/**
 预览图所用尺寸

 @param picWidth 图片宽
 @param picHeight 图片高
 @return 新尺寸
 */
+ (CGSize)getImageShowSizewithWidth:(float)picWidth Height:(float)picHeight {
    
    if (!(picWidth > 0 && picHeight > 0)) {
        return CGSizeMake(0.0, 0.0);
    }
    
    CGSize size = CGSizeMake(picWidth, picHeight);
    int tag;
    if (picHeight > picWidth) { //竖
        if (picHeight/picWidth > 3.0) {
            tag = 3;//竖长图
        } else {
            tag = 2;//竖图
        }
    } else { //横
        if (picWidth/picHeight > 3.0) {
            tag = 4;//横长图
        }else{
            tag = 1;//横图
        }
    }
    
    switch (tag) {
        case 1:{
            size = CGSizeMake(kPhotoScreenWidth,kPhotoScreenWidth*picHeight/picWidth);
            break;
        }
        case 2:{
            if (kPhotoScreenWidth*picHeight/picWidth>kPhotoScreenHeight){
                size = CGSizeMake(kPhotoScreenHeight*picWidth/picHeight, kPhotoScreenHeight);
            } else {
                size = CGSizeMake( kPhotoScreenWidth, kPhotoScreenWidth*picHeight/picWidth);
            }
            break;
        }
        case 3:{
            if(picWidth < kPhotoScreenWidth/2.0){
                size = CGSizeMake(picWidth*2.0, picHeight*2.0);
            } else {
                size = CGSizeMake(kPhotoScreenWidth, kPhotoScreenWidth*picHeight/picWidth);
            }
            break;
        }
        case 4:{
            size = CGSizeMake(kPhotoScreenWidth, kPhotoScreenWidth*picHeight/picWidth);
            break;
        }
    }
    return size;
}

@end
