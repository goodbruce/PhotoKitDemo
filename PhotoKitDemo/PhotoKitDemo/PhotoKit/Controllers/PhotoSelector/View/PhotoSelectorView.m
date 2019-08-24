//
//  PhotoSelectorView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoSelectorView.h"
#import "PhotoKitViewUtils.h"

#define K_COLOR_GRAY_BG           [UIColor colorWithHexString:@"efeff4"]

@implementation PhotoSelectorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        self.collectionView.contentInset = UIEdgeInsetsMake(4.0, 4.0, 54.0, 4.0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
        [self addSubview:_collectionView];
        
        self.toolBar = [[SelectorMediaBar alloc] initWithFrame:CGRectZero];
        self.toolBar.userInteractionEnabled = YES;
        [self addSubview:self.toolBar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGFloat barHeight = [SelectorMediaBar barHeight];
    self.toolBar.frame = CGRectMake(0.0, CGRectGetHeight(bounds)-barHeight, CGRectGetWidth(bounds), barHeight);
    self.collectionView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - [PhotoKitViewUtils baseSafeAreaEdgeInsets].bottom);
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.collectionView.dataSource = _delegate;
    self.collectionView.delegate = _delegate;
    self.toolBar.delegate = _delegate;
}

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

@end
