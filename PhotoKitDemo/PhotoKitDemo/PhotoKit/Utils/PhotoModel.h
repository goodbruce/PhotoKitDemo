//
//  PhotoModel.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

//媒体资源类型
typedef NS_ENUM(NSInteger, MediaMode) {
    MediaPhotoMode,         //普通相片
    MediaVideoMode,         //视频
    MediaGifMode,           //git动图
    MediaPhotoliveMode,     //photo live
};

@interface PhotoModel : NSObject

@property (nonatomic, strong) PHAsset *phasset;     //媒体资源
@property (nonatomic, strong) NSString *identifier; //媒体资源唯一标示
@property (nonatomic, assign) BOOL selected;        //是否选中 YES 为选中， NO 为未选中

@property (nonatomic, assign) MediaMode mediaMode;  //媒体资源类型

@end
