//
//  PhotoKitManager.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PhotoModel.h"
#import "AlbumModel.h"
#import "SVProgressHUD.h"
#import "PhotoKitDefine.h"

@interface PhotoKitManager : NSObject

/**
 切换的当前相册
 */
@property (nonatomic, strong) AlbumModel *currentAlbumModel;

/**
 选中的媒体资源
 */
@property (nonatomic, strong) NSMutableDictionary *selectedAlbumMedias;

/**
 最大选中图片的数量,允许选择的最大图片数量, 默认:6, 不限制: < 0;
 */
@property (nonatomic, assign) NSInteger maxPhotoSelectedCount;

/**
 最大选中视频的数量,允许选择的最大视频数量, 默认:1, 不限制: < 0;
 */
@property (nonatomic, assign) NSInteger maxVideoSelectedCount;

+ (instancetype)shareInstance;

/**
 用户访问相册权限判断
 
 @return 相册权限判断, 是否有权限，YES为未知或者有权限 NO没有权限
 */
- (BOOL)authorizationAlbumStatus;

/**
 用户访问相机权限判断
 
 @return 相机权限判断, 是否有权限，YES为未知或者有权限 NO没有权限
 */
- (BOOL)authorizationCameraStatus;

/**
 清空数据
 */
- (void)clearData;

/**
 获取相册列表

 @return 相册列表
 */
- (NSMutableArray *)getAlbums;

/**
 根据需要显示的类型获取相册

 @param needMediaType needMediaType需要显示的资源类型
 @return 相册列表
 */
- (NSMutableArray *)getAlbumsNeedMediaType:(NeedShowMediaType)needMediaType;


/**
 判断相册是否是相机胶卷

 @param model model
 @return 是否为相机胶卷
 */
- (BOOL)isCameraRollOfAlbumModel:(AlbumModel *)model;

/**
 根据类型和相册获取媒体资源

 @param albumModel 相册
 @param needMediaType 需要显示的媒体资源类型
 @return 媒体资源
 */
- (NSMutableArray *)getMediasOfAlbum:(AlbumModel *)albumModel needMediaType:(NeedShowMediaType)needMediaType;

/**
 根据相册获取所有媒体资源

 @param albumModel 相册model数据
 @return 相册中所有媒体资源
 */
- (NSMutableArray *)getMediasOfAlbum:(AlbumModel *)albumModel;

/**
 根据相册获取所有照片
 
 @param albumModel 相册model数据
 @return 相册中所有照片
 */
- (NSMutableArray *)getPhotosOfAlbum:(AlbumModel *)albumModel;

/**
 根据相册获取所有视频
 
 @param albumModel 相册model数据
 @return 相册中所有视频
 */
- (NSMutableArray *)getVideosOfAlbum:(AlbumModel *)albumModel;

/**
 根据相册获取所有动图GIF
 
 @param albumModel 相册model数据
 @return 相册中所有动图GIF
 */
- (NSMutableArray *)getGifsOfAlbum:(AlbumModel *)albumModel;

/**
 根据相册获取所有PhotoLives
 
 @param albumModel 相册model数据
 @return 相册中所有PhotoLives
 */
- (NSMutableArray *)getPhotoLivesOfAlbum:(AlbumModel *)albumModel;

/**
 根据PHAsset获取图片信息

 @param asset PHAsset
 @param targetSize 目标
 @param resultHandler block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)reqImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler;

/**
 根据PHAsset获取图片信息, 作为相册的缩略图

 @param asset PHAsset
 @param targetSize 目标
 @param resultHandler block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)reqAblumImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler;

/**
 根据PHAsset获取AVAsset
 
 @param asset PHAsset
 @param completion block
 @param failure block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset completion:(void(^)(AVAsset *asset))completion failure:(void(^)(void))failure;

/**
 根据PHAsset获取PlayerItem

 @param asset PHAsset
 @param completion block
 @param failure block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset completion:(void(^)(AVPlayerItem *playerItem))completion failure:(void(^)(void))failure;

/**
 根据PHAsset获取AVAsset
 
 @param asset PHAsset
 @return AVAsset
 */
- (AVAsset *)getAVAssetForVideo:(PHAsset *)asset;

/**
 根据PHAsset获取AVPlayerItem
 
 @param asset PHAsset
 @return AVAsset
 */
- (AVPlayerItem *)getPlayerItemForVideo:(PHAsset *)asset;

/**
 相册名称转换，转换成中文
 
 @param englishName 英文
 @return 中文
 */
- (NSString *)transFormPhotoTitle:(NSString *)englishName;

/**
 是否包括在已经选中的列表中了
 
 @param model model
 @return 是否在 YES OR NO
 */
- (BOOL)containMediaInSelectedList:(PhotoModel *)model;

/**
 找出 identifier标示的下标

 @param identifier 唯一标识
 @return 下标Index
 */
- (NSInteger)indexOfPhotoInSelectedList:(NSString *)identifier;

/**
 选中的媒体资源是否包含视频

 @return YES oR NO
 */
- (BOOL)hasVideoInSelectedList;

/**
 选中的媒体资源是否包含tup
 
 @return YES oR NO
 */
- (BOOL)hasPhotoInSelectedList;

/**
 选中的媒体资源是否包含livePhoto
 
 @return YES oR NO
 */
- (BOOL)hasPhotoLiveInSelectedList;

/**
 选中的媒体资源是否包含GIF
 
 @return YES oR NO
 */
- (BOOL)hasGIFInSelectedList;

/**
 选中的媒体资源是否包含非视频 媒体资源
 
 @return YES oR NO
 */
- (BOOL)hasNotVideoMediaInSelectedList;

/**
 将媒体资源model添加到选中列表中
 
 @param model model model
 @return 最后model，如果在选中列表了，则返回YES
 */
- (BOOL)addSelectedPhotoModel:(PhotoModel *)model;

@end
