//
//  VideoPreviewView.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPreviewNavBar.h"
#import "SelectorMediaBar.h"
#import "PhotoKitDefine.h"
#import "PhotoKitViewUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "ProgressSlider.h"

@protocol VideoPreviewViewDelegate;
@interface VideoPreviewView : UIView

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) SelectorMediaBar *selectorBar;
@property (nonatomic, strong) PhotoPreviewNavBar *selectorNavBar;
@property (nonatomic, assign, getter = isBarHidden) BOOL barHidden;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id<VideoPreviewViewDelegate>buttonDelegate;

@end

@protocol VideoPreviewViewDelegate <NSObject>

- (void)playOrPauseDidClicked:(UIButton *)button;
- (void)handleSingleDidTaped;

@end
