//
//  ProgressSlider.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/6.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

//图片的方向
typedef NS_ENUM(NSInteger, ProgressSliderDirection) {
    ProgressSliderHorizontal = 0,       //图片为横屏
    ProgressSliderVertical,             //图片为竖屏
};

@interface ProgressSlider : UIControl

@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat sliderPercent;//滑动百分比
@property (nonatomic, assign) CGFloat progressPercent;//缓冲的百分比

@property (nonatomic, assign) BOOL isSliding;//是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱

@property (nonatomic, assign) ProgressSliderDirection direction;//方向

- (id)initWithFrame:(CGRect)frame direction:(ProgressSliderDirection)direction;

@end
