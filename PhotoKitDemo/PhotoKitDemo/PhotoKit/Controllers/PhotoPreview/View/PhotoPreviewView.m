//
//  PhotoPreviewView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoPreviewView.h"

@interface PhotoPreviewView ()

@end

@implementation PhotoPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        _selectorNavBar = [[PhotoPreviewNavBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_selectorNavBar];
        
        _selectorBar = [[SelectorMediaBar alloc]initWithFrame:CGRectZero];
        _selectorBar.previewButton.hidden = YES;
        _selectorBar.backImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_selectorBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    self.collectionView.frame = bounds;
    
    self.selectorNavBar.frame = CGRectMake(CGRectGetMinX(bounds), 0.0, CGRectGetWidth(bounds), (kPhotoStatusBarHeight+44.0));
    self.selectorBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - 50.0 - [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom, CGRectGetWidth(bounds), 50.0 + [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom);
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.selectorNavBar.delegate = _delegate;
    self.selectorBar.delegate = _delegate;
    
    self.collectionView.dataSource = _delegate;
    self.collectionView.delegate = _delegate;
}

- (void)setBarHidden:(BOOL)barHidden {
    _barHidden = barHidden;
    NSTimeInterval duration = 0.5;
    if (_barHidden) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame1 = self.selectorNavBar.frame;
            frame1.origin.y = -(kPhotoStatusBarHeight+44.0);
            self.selectorNavBar.frame = frame1;
            CGRect frame2 = self.selectorBar.frame;
            frame2.origin.y = CGRectGetHeight(self.bounds);
            self.selectorBar.frame = frame2;
        } completion:nil];
    } else {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame1 = self.selectorNavBar.frame;
            frame1.origin.y = 0.0;
            self.selectorNavBar.frame = frame1;
            CGRect frame2 = self.selectorBar.frame;
            frame2.origin.y = CGRectGetHeight(self.bounds) - (CGRectGetHeight(self.selectorBar.frame));
            self.selectorBar.frame = frame2;
        } completion:nil];
    }
}

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

@end
