//
//  VideoPreviewPresenter.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "VideoPreviewPresenter.h"
#import "PhotoKitManager.h"

@interface VideoPreviewPresenter ()

/**
 视频播放完成，标示，YES为播放完成，
 */
@property (nonatomic, assign) BOOL videoPlayFinished;

/**
 当前播放的视频model
 */
@property (nonatomic, strong) PhotoModel *currentVideoModel;

@end

@implementation VideoPreviewPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoPlayFinished = NO;
        [self addNotifications];
    }
    return self;
}

- (void)addNotifications {
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self removeObserveWithPlayerItem:self.avPlayerItem];
}

/**
 视频播放完成
 */
- (void)moviePlayDidEnd {
    self.videoPlayFinished = YES;
    self.videoPreviewView.playButton.hidden = NO;
    self.videoPreviewView.barHidden = NO;
}

#pragma mark 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserveWithPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

//移除处观察者
- (void)removeObserveWithPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)startPlayerVideo {
    
    NSMutableArray *currentAlbums = [[PhotoKitManager shareInstance] getVideosOfAlbum:[PhotoKitManager shareInstance].currentAlbumModel];
    NSLog(@"currentPhotoIdentifier:%@",self.currentVideoIdentifier);
    PhotoModel *selectedPhotoModel;
    for (PhotoModel *model in currentAlbums) {
        NSLog(@"model.identifier:%@",self.currentVideoIdentifier);
        if (self.currentVideoIdentifier && [self.currentVideoIdentifier isEqualToString:model.phasset.localIdentifier]) {
            selectedPhotoModel = model;
            break;
        }
    }

    self.currentVideoModel = selectedPhotoModel;
    if (selectedPhotoModel) {
        __weak typeof(self) weakSelf = self;
        [[PhotoKitManager shareInstance] requestPlayerItemForVideo:selectedPhotoModel.phasset completion:^(AVPlayerItem *playerItem) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.avPlayerItem = playerItem;
            //[strongSelf addObserveWithPlayerItem:strongSelf.avPlayerItem];
            
            strongSelf.avPlayer = [AVPlayer playerWithPlayerItem:strongSelf.avPlayerItem];
            strongSelf.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:strongSelf.avPlayer];
            strongSelf.videoPreviewView.playerLayer = strongSelf.avPlayerLayer;
            
            //开始不隐藏工具按钮
            [strongSelf changedAvplayerStatus:NO];
        } failure:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
        }];
        
        //如果已经选中，则显示选中标示
        [self setNavBarSelectionModel:self.currentVideoModel animated:NO];
    }
}

#pragma - PhotoPreviewNavBarDelegate
- (void)back {
    if (self.popControllerHandler) {
        self.popControllerHandler(nil);
    }
}

/**
 点击选择按钮标识
 */
- (void)handleSelectDidClicked {
    PhotoModel *photoModel = self.currentVideoModel;
    if (photoModel == nil) {
        //找不到，直接返回
        return;
    }
    
    //视频限制数量和图片不一样
    if (photoModel.mediaMode == MediaVideoMode) {
        if ([[PhotoKitManager shareInstance] hasNotVideoMediaInSelectedList]) {
            //如果当前点击要选中视频，之前已经有非视频了，则不能选中
            [SVProgressHUD showErrorWithStatus:kCantSelectedPhotoVideoTips];
            return;
        }
    } else {
        if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
            //如果当前点击要视频，之前已经有视频了，则不能选中第二个视频
        }
    }
    
    BOOL hasVideo = NO;
    if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
        //如果当前点击要选中图片，之前已经有视频了，则不能选中
        hasVideo = YES;
    }
    
    NSInteger maxMediaCount = (hasVideo?[PhotoKitManager shareInstance].maxVideoSelectedCount:[PhotoKitManager shareInstance].maxPhotoSelectedCount);
    BOOL hasContainPhoto = [[PhotoKitManager shareInstance] containMediaInSelectedList:photoModel];
    if (!hasContainPhoto) {
        //如果不存在选中列表，则添加到选中列表中
        if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count >= maxMediaCount) {
            [SVProgressHUD showErrorWithStatus:(hasVideo?kMaxSelectedVideoTips:kMaxSelectedPhotoTips)];
        } else {
            [[PhotoKitManager shareInstance].selectedAlbumMedias setObject:photoModel forKey:photoModel.phasset.localIdentifier];
        }
    } else {
        [[PhotoKitManager shareInstance].selectedAlbumMedias removeObjectForKey:photoModel.phasset.localIdentifier];
    }
    
    [self setNavBarSelectionModel:photoModel animated:YES];
}

#pragma - VideoPreviewViewDelegate
- (void)setNavBarSelectionModel:(PhotoModel *)model animated:(BOOL)animated {
    BOOL hasContainPhoto = [[PhotoKitManager shareInstance] containMediaInSelectedList:model];
    [self.videoPreviewView.selectorNavBar setCurrentSelected:hasContainPhoto animated:animated];
    
    [self.videoPreviewView.selectorBar setSelectedBarCount:[PhotoKitManager shareInstance].selectedAlbumMedias.allValues.count];
}

#pragma - VideoPreviewViewDelegate
- (void)playOrPauseDidClicked:(UIButton *)button {
    [self changedAvplayerStatus:YES];
}

- (void)handleSingleDidTaped {
    [self changedAvplayerStatus:YES];
}

- (void)changedAvplayerStatus:(BOOL)barNeedAnmiated {
    if (self.videoPlayFinished) {
        //如果已经播放完成后，点击按钮，点击屏幕重新播放
        if (!self.avPlayer) {
            return;
        }
        CGFloat secs = 0;
        NSInteger dragedSeconds = floorf(secs);
        CMTime cmTime = CMTimeMake(dragedSeconds, 1);
        [self.avPlayer seekToTime:cmTime];
        [self.avPlayer play];
        self.videoPlayFinished = NO;
        self.videoPreviewView.playButton.hidden = YES;
        if (barNeedAnmiated) {
            //工具栏按钮需要动画时候，则显示，点击屏幕，点击播放按钮是，需要动画
            self.videoPreviewView.barHidden = YES;
        }
    } else {
        //rate,当为1时是正常播放状态,为0时是暂停状态,通过这个属性可以用来判断播放还是暂停
        if (self.avPlayer.rate == 1) {
            [self.avPlayer pause];
            self.videoPreviewView.playButton.hidden = NO;
            if (barNeedAnmiated) {
                //工具栏按钮需要动画时候，则显示，点击屏幕，点击播放按钮是，需要动画
                self.videoPreviewView.barHidden = NO;
            }
        } else {
            [self.avPlayer play];
            self.videoPreviewView.playButton.hidden = YES;
            if (barNeedAnmiated) {
                //工具栏按钮需要动画时候，则显示，点击屏幕，点击播放按钮是，需要动画
                self.videoPreviewView.barHidden = YES;
            }
        }
    }
}

#pragma - SelectorMediaBarDelegate
/**
 预览按钮点击
 */
- (void)previewButtonDidClicked {
    
}

/**
 完成/下一步按钮点击
 */
- (void)completeButtonDidClicked {
    
}

/**
 数量按钮点击
 */
- (void)numberButtonDidClicked {
    
}

#pragma - dealloc
- (void)dealloc {
    [self removeNotifications];
}

#pragma - SETTER/GETTER
- (VideoPreviewView *)videoPreviewView {
    if (!_videoPreviewView) {
        _videoPreviewView = [[VideoPreviewView alloc] initWithFrame:CGRectZero];
    }
    return _videoPreviewView;
}

@end
