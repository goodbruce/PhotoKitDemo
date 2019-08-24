//
//  PhotoSelectorPresenter.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoSelectorView.h"
#import "PhotoKitDefine.h"

//presenter通知Controller操作类型
#define PresenterHandlerTypeKey @"handlerType"

//导航的name
#define NavMenuButtonNameKey    @"name"

//导航按钮的actve
#define NavMenuButtonActiveKey  @"active"

//预览时传递的图片identifier
#define PhotoPreviewIDKey       @"identifier"

//是否预览当前选中的图片
#define PhotoPreviewSelectedKey  @"selected"

//是否预览当前选中的图片
#define PhotoPreviewSelectedKey  @"selected"

//预览的媒体类型
#define PreviewMediaTypeKey @"mediaType"

//presenter通知Controller默认操作
typedef NS_ENUM(NSInteger, PresenterHandlerType) {
    PresenterHandlerDefault,           //默认
    PresenterHandlerUpdateNav,         //更新导航操作
    PresenterHandlerPushPreview        //跳转到预览页面
};

//预览的媒体类型
typedef NS_ENUM(NSInteger, PreviewMediaType) {
    PreviewMediaTypePhoto,           //默认是图片
    PreviewMediaTypeVideo,           //视频
};


@interface PhotoSelectorPresenter : NSObject

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
 显示控件view
 */
@property (nonatomic, strong) PhotoSelectorView *photoSelectorView;

/**
 每一行显示数量，默认为 4
 */
@property (nonatomic, assign) NSInteger column;

/**
 超出数量，或者规定类型，不能再选中，默认为YES
 */
@property(nonatomic, readonly, getter=isSelectable) BOOL selectable;

/**
 需要显示的媒体资源类型，默认仅仅为图片
 */
@property (nonatomic, assign) NeedShowMediaType needMediaType;

/**
 注册cell
 */
- (void)registerCollectionCell;

/**
 加载相机胶卷
 */
- (void)loadCameraMedias;

/**
 重新刷新界面
 */
- (void)reloadViewSelectedMedia;

/**
 点击导航取消按钮操作
 */
- (void)leftNavItemClicked;

/**
 点击导航titleView切换相册
 
 @param showNavMenu 是否隐藏与消失 YES，为显示 NO为隐藏
 */
- (void)navMenuItemClicked:(BOOL)showNavMenu;

@end
