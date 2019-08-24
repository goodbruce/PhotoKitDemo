//
//  PhotoPreviewPresenter.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoPreviewView.h"
#import "PhotoPreviewCollectionViewCell.h"
#import "PhotoKitManager.h"

@interface PhotoPreviewPresenter : NSObject

@property (nonatomic, strong) PhotoPreviewView *photoPreviewView;

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
 当前选中的图片
 */
@property (nonatomic, strong) NSString *currentPhotoIdentifier;

/**
 是否预览选中的图片
 */
@property (nonatomic, assign) BOOL isShowSelected;

/**
 当前选中的相册
 */
@property (nonatomic, strong) AlbumModel *currentAlbumModel;

/**
 加载显示的图片并且滚动到选中的图片的位置
 */
- (void)loadPhotoPreviewItems;

/**
 滚动到选中的图片的位置
 */
- (void)scrollSelectedItem;


/**
 注册cell
 */
- (void)registerCollectionCell;

@end
