//
//  PhotoKitDefine.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#ifndef PhotoKitDefine_h
#define PhotoKitDefine_h

#define kPhotoStatusBarHeight CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
#define kPhotoScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPhotoScreenWidth [UIScreen mainScreen].bounds.size.width

#define kCantSelectedPhotoVideoTips @"照片和视频不能同时选择"

#define kMaxSelectedPhotoTips       @"最多选择6张照片"

#define kMaxSelectedVideoTips       @"最多选择1个视频"

//需要显示的媒体资源类型，默认仅仅为图片
typedef NS_ENUM(NSInteger, NeedShowMediaType) {
    NeedShowMediaTypePhoto = 0,       //默认仅仅为图片
    NeedShowMediaTypeVideo,           //视频
    NeedShowMediaTypeGIF,             //GIF
    NeedShowMediaTypePhotoLive,       //PhotoLive
    NeedShowMediaTypeAll,             //所有
};

/**
 popController操作的block，返回上一页面，导航pop
 */
typedef void (^PopControllerHandler)(id data);

/**
 dismissController操作的block，返回上一页面，模态dismiss
 */
typedef void (^DismissControllerHandler)(id data);

/**
 PresentControllerHandler操作的block，跳转到新的页面
 */
typedef void (^PresentControllerHandler)(UIViewController *controller, id data);

/**
 PresentHandler操作的block，通知Controller作出相应的处理
 */
typedef void (^PresenterHandler)(id data);


#endif /* PhotoKitDefine_h */
