//
//  PhotoPreviewCollectionViewCell.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoPreviewCollectionViewCell.h"

@interface PhotoPreviewCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, assign, getter = isDoubleTap) BOOL doubleTap;

@property (nonatomic, strong) UIImage *photo;

@end

@implementation PhotoPreviewCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.clipsToBounds = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _photoView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _photoView.clipsToBounds = YES;
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_photoView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)setPhotoModel:(PhotoModel *)photoModel {
    _photoModel = photoModel;
    
    CGSize showSize = [PhotoKitViewUtils getImageShowSizewithWidth:photoModel.phasset.pixelWidth Height:photoModel.phasset.pixelHeight];
    
    __weak typeof(self) weakSelf = self;
    [[PhotoKitManager shareInstance] reqImageForAsset:photoModel.phasset targetSize:showSize resultHandler:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.photo = result;
    }];
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    if (!_photo) {
        return;
    }
    self.photoView.image = _photo;
    [self adjustFrame];
}

#pragma mark 调整frame
- (void)adjustFrame
{
    if (!self.photo) {
        return;
    }
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    if (boundsHeight == 0 || boundsWidth == 0) {
        return;
    }
    CGSize imageSize = self.photo.size;
    CGSize showSize = [PhotoKitViewUtils getImageShowSizewithWidth:imageSize.width Height:imageSize.height];
    CGFloat imageWidth = showSize.width;
    CGFloat imageHeight = showSize.height;
    
    // 设置伸缩比例
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    
    CGRect imageBounds = CGRectMake(0, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(imageBounds));
    CGPoint imageCenter;
    if (showSize.height>kPhotoScreenHeight) {
        imageCenter = CGPointMake(kPhotoScreenWidth / 2, showSize.height / 2);
    }else{
        imageCenter = CGPointMake(boundsWidth / 2, boundsHeight / 2);
    }
    self.photoView.center = imageCenter;
    self.photoView.bounds = imageBounds;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat w = scrollView.bounds.size.width;
    CGFloat h = scrollView.bounds.size.height;
    CGFloat iw = self.photoView.frame.size.width;
    CGFloat ih = self.photoView.frame.size.height;
    self.photoView.center = CGPointMake(MAX(w, iw) / 2, MAX(h, ih) / 2);
}

#pragma mark - Tap Handler
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    self.doubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self.scrollView];
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    self.doubleTap = NO;
    [self performSelector:@selector(callBack) withObject:nil afterDelay:0.2];
}

- (void)callBack {
    if (self.doubleTap) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayCollectionCellPhotoViewTapped:)]) {
        [self.delegate displayCollectionCellPhotoViewTapped:self];
    }
}

@end
