//
//  VideoPreviewPresenter.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPreviewView.h"

@interface VideoPreviewPresenter : NSObject

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerItem *avPlayerItem;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;

@property (nonatomic, strong) VideoPreviewView *videoPreviewView;

/**
 pop回到上一个页面
 */
@property (nonatomic, copy) PopControllerHandler popControllerHandler;

/**
 模态弹出
 */
@property (nonatomic, copy) PresentControllerHandler presentController;

/**
 模态消失
 */
@property (nonatomic, copy) DismissControllerHandler dismissControllerHandler;

/**
 通知Controller作出相应的处理
 */
@property (nonatomic, copy) PresenterHandler presenterHandler;

/**
 当前选中的Video
 */
@property (nonatomic, strong) NSString *currentVideoIdentifier;

- (void)startPlayerVideo;

@end
