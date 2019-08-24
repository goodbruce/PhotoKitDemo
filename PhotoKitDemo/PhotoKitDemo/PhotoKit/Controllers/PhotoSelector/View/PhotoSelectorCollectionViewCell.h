//
//  PhotoSelectorCollectionViewCell.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

typedef NS_ENUM(NSInteger, PhotoSelectorAnimationMode) {
    PhotoSelectorAnimationModeDefault         //默认类型
};

@protocol PhotoSelectorCollectionViewCellDelegate;
@interface PhotoSelectorCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<PhotoSelectorCollectionViewCellDelegate>delegate;

/**
 相册媒体资源model
 */
@property (nonatomic, strong) PhotoModel *photoModel;

/**
 选中的动画类型
 */
@property (nonatomic, assign) PhotoSelectorAnimationMode *selectedMode; //选中的动画类型

/**
 超出数量，或者规定类型，不能再选中，默认为YES
 */
@property(nonatomic, getter=isSelectable) BOOL selectable;

/**
 设置是否选中

 @param selecteded 是否选中
 @param animated 是否有动画效果
 */
- (void)setMarkSelected:(BOOL)selecteded animated:(BOOL)animated;

@end

/**
 代理协议
 */
@protocol PhotoSelectorCollectionViewCellDelegate <NSObject>

/**
 点击选择当前标记cell

 @param cell 当前cell
 */
- (void)photoSelectorMarkDidClicked:(PhotoSelectorCollectionViewCell *)cell;

/**
 点击选择当前cell 进入预览页面

 @param cell 当前cell
 */
- (void)photoSelectorPreviewDidClicked:(PhotoSelectorCollectionViewCell *)cell;

@end
