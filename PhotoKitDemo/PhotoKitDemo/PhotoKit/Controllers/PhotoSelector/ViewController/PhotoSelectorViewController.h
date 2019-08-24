//
//  PhotoSelectorViewController.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoKitDefine.h"
#import "PhotoKitManager.h"

@interface PhotoSelectorViewController : UIViewController

/**
 需要显示的媒体资源类型，默认仅仅为图片
 */
@property (nonatomic, assign) NeedShowMediaType needMediaType;

/**
 需要的图片数量，单聊为一张图，发帖为最多限制6张
 */
@property (nonatomic, assign) NSInteger needMaxPhotoCount;

/**
 需要的视频数量，默认为一个视频
 */
@property (nonatomic, assign) NSInteger needMaxVideoCount;


@end
