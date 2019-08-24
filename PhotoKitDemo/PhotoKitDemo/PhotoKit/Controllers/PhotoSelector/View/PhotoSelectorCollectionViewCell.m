//
//  PhotoSelectorCollectionViewCell.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoSelectorCollectionViewCell.h"
#import "SelectorMarkView.h"
#import "MediaMarkView.h"
#import "PhotoKitManager.h"

static CGFloat kSelectedMarkSize = 30.0;

static CGFloat kMediaMarkWidth = 36.0;

static CGFloat kMediaMarkHeight = 16.0;

@interface PhotoSelectorCollectionViewCell ()<SelectorMarkViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;       //图片控件
@property (nonatomic, strong) SelectorMarkView *markView;   //是否选中的标记

@property (nonatomic, strong) MediaMarkView *mediaView;     //媒体资源类型标示

@property (nonatomic, strong) UIView *disableView;          //不能选择的遮罩

@end


@implementation PhotoSelectorCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;

        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _markView = [[SelectorMarkView alloc]initWithFrame:CGRectZero];
        _markView.animated = YES;
        _markView.delegate = self;
        _markView.layer.cornerRadius = 4;
        _markView.layer.masksToBounds = YES;
        [self.contentView addSubview:_markView];
        
        _mediaView = [[MediaMarkView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_mediaView];
        
        _disableView = [[UIView alloc]initWithFrame:CGRectZero];
        _disableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _disableView.exclusiveTouch = YES;
        [self.contentView addSubview:_disableView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [self.contentView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.imageView.frame = bounds;
    
    self.mediaView.frame = CGRectMake(CGRectGetWidth(bounds)-kMediaMarkWidth, CGRectGetHeight(bounds)-kMediaMarkHeight, kMediaMarkWidth, kMediaMarkHeight);
    
    self.markView.frame = CGRectMake(CGRectGetWidth(bounds)-kSelectedMarkSize, 0.0, kSelectedMarkSize, kSelectedMarkSize);
    
    self.disableView.frame = bounds;
}

- (void)setPhotoModel:(PhotoModel *)photoModel {
    _photoModel = photoModel;
    
    NSString *type;
    BOOL hidenMediaMark = NO;
    switch (photoModel.mediaMode) {
        case MediaPhotoMode: {
            type = @"";
            hidenMediaMark = YES;
            break;
        }
        case MediaPhotoliveMode: {
            type = @"Live";
            break;
        }
        case MediaGifMode: {
            type = @"GIF";
            break;
        }
        case MediaVideoMode: {
            type = @"Video";
            break;
            
        }
        default: {
            hidenMediaMark = YES;
            break;
        }
    }
    self.mediaView.hidden = hidenMediaMark;
    self.mediaView.mediaTitle = type;
    
    CGSize targetSize = CGSizeMake((([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5, (([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5);
    
    __weak typeof(self) weakSelf = self;
    [[PhotoKitManager shareInstance] reqImageForAsset:photoModel.phasset targetSize:targetSize resultHandler:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.imageView setImage:result];
    }];
}

/**
 设置是否选中
 
 @param selecteded 是否选中
 @param animated 是否有动画效果
 */
- (void)setMarkSelected:(BOOL)selecteded animated:(BOOL)animated {
    [self updateSelectedStatus:selecteded];
    [self.markView setMarkSelected:selecteded animated:animated];
}

/**
 判断是否可以再进行选中操作

 @param selectable 是否可以不能再选中
 */
- (void)setSelectable:(BOOL)selectable {
    _selectable = selectable;
    self.disableView.hidden = selectable;
    
    if (self.photoModel.selected) {
        self.disableView.hidden = self.photoModel.selected;
    }
}

/**
 更新选中的状态

 @param selected 是否选中
 */
- (void)updateSelectedStatus:(BOOL)selected {
    self.photoModel.selected = selected;
    if (self.photoModel.selected) {
        self.disableView.hidden = self.photoModel.selected;
    }
}

#pragma mark - TapHandler
- (void)handleSingleTap:(UITapGestureRecognizer*)singleTapGestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoSelectorPreviewDidClicked:)]) {
        [self.delegate photoSelectorPreviewDidClicked:self];
    }
}

#pragma mark - SelectorMarkViewDelegate
- (void)selectorMarkDidClicked:(SelectorMarkView *)view {
    self.photoModel.selected = view.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoSelectorMarkDidClicked:)]) {
        [self.delegate photoSelectorMarkDidClicked:self];
    }
}

@end
