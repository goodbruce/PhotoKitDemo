//
//  VideoPreviewView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "VideoPreviewView.h"

static CGFloat kPlayButtonSize = 50.0;

@interface VideoPreviewView ()

@end

@implementation VideoPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectorNavBar = [[PhotoPreviewNavBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_selectorNavBar];
        
        _selectorBar = [[SelectorMediaBar alloc]initWithFrame:CGRectZero];
        _selectorBar.previewButton.hidden = YES;
        _selectorBar.backImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_selectorBar];
        
        //播放按钮
        _playButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playButton setImage:[UIImage imageNamed:@"ic_video_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
        [self addSubview:_playButton];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.playerLayer.frame = self.bounds;
    self.playButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - kPlayButtonSize)/2, (CGRectGetHeight(self.bounds) - kPlayButtonSize)/2, kPlayButtonSize, kPlayButtonSize);
    
    self.selectorNavBar.frame = CGRectMake(CGRectGetMinX(bounds), 0.0, CGRectGetWidth(bounds), (kPhotoStatusBarHeight+44.0));
    
    self.selectorBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - 50.0 - [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom, CGRectGetWidth(bounds), 50.0 + [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom);
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.selectorNavBar.delegate = _delegate;
    self.selectorBar.delegate = _delegate;
    self.buttonDelegate = _delegate;
}

- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer {
    _playerLayer = playerLayer;
    _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    
    [self setNeedsLayout];
}

- (void)setBarHidden:(BOOL)barHidden {
    _barHidden = barHidden;
    NSTimeInterval duration = 0.5;
    if (_barHidden) {
        CGRect frame1 = self.selectorNavBar.frame;
        frame1.origin.y = -(kPhotoStatusBarHeight+44.0);
        
        CGRect frame2 = self.selectorBar.frame;
        frame2.origin.y = CGRectGetHeight(self.bounds);
        
        [UIView animateWithDuration:duration animations:^{
            self.selectorNavBar.frame = frame1;
            self.selectorBar.frame = frame2;
        } completion:nil];
    } else {
        CGRect frame1 = self.selectorNavBar.frame;
        frame1.origin.y = 0.0;
        CGRect frame2 = self.selectorBar.frame;
        frame2.origin.y = CGRectGetHeight(self.bounds) - (CGRectGetHeight(self.selectorBar.frame));
        [UIView animateWithDuration:duration animations:^{
            self.selectorNavBar.frame = frame1;
            self.selectorBar.frame = frame2;
        } completion:nil];
    }
}

- (void)playOrPauseAction:(UIButton *)button {
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(playOrPauseDidClicked:)]) {
        [self.buttonDelegate playOrPauseDidClicked:button];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(handleSingleDidTaped)]) {
        [self.buttonDelegate handleSingleDidTaped];
    }
}

- (void)dealloc {
    
}

@end
