//
//  AlbumModel.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoModel.h"

/**
 每个相册的模型
 */
@interface AlbumModel : NSObject

/**
 相册名称
 */
@property (nonatomic, strong) NSString *albumName;

/**
 相册中文名称
 */
@property (nonatomic, strong) NSString *albumNameCh;

/**
 封面Asset
 */
@property (nonatomic, strong) PHAsset *asset;

/**
 照片集合对象
 */
@property (nonatomic, strong) PHFetchResult *result;

@end
