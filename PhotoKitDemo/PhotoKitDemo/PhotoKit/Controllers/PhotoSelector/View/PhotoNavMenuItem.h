//
//  PhotoNavMenuItem.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlbumModel.h"

typedef void (^PhotoNavMenuItemAction)(void);

@interface PhotoNavMenuItem : NSObject

/**
 tag标记
 */
@property (nonatomic, assign) NSInteger tag;

/**
 显示的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 标题title
 */
@property (nonatomic, strong) NSString *title;

/**
 标题title颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 描述subTitle
 */
@property (nonatomic, strong) NSString *subTitle;

/**
 描述subTitle颜色
 */
@property (nonatomic, strong) UIColor *subTitleColor;

/**
 处理事件
 */
@property (nonatomic, copy) PhotoNavMenuItemAction action;

/**
 是否选中
 */
@property (nonatomic, assign, getter = isSelected) BOOL selected;

/**
 相册model
 */
@property (nonatomic, strong) AlbumModel *albumModel;


@end
