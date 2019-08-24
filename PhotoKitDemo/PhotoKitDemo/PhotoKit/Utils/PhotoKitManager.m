//
//  PhotoKitManager.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoKitManager.h"

@interface PhotoKitManager ()

@property (nonatomic, strong) __block NSMutableArray *photoAlbums;

@end

@implementation PhotoKitManager

+ (instancetype)shareInstance{
    static PhotoKitManager *_shareInstace = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _shareInstace = [[self alloc] init];
        _shareInstace.photoAlbums = [NSMutableArray arrayWithCapacity:0];
        _shareInstace.maxPhotoSelectedCount = 6; //最大可以选中6张图
        _shareInstace.maxVideoSelectedCount = 1; //最多选中一个视频，图片和视频不能同时选择
        _shareInstace.selectedAlbumMedias = [NSMutableDictionary dictionaryWithCapacity:0];
    });
    return _shareInstace;
}

/**
 用户访问相册权限判断

 @return 相册权限判断
 */
- (BOOL)authorizationAlbumStatus {
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (appName == nil) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }

    BOOL hasAuthStatus = YES;
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined: {
            NSLog(@"未询问用户是否授权");
            break;
        }
        case PHAuthorizationStatusRestricted: {
            NSLog(@"未授权，例如家长控制");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"请在iPhone“设置-隐私-相册”选项中，允许%@访问你的相册。",appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            hasAuthStatus = NO;
            break;
        }
        case PHAuthorizationStatusDenied: {
            NSLog(@"未授权，用户拒绝造成的");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"请在iPhone“设置-隐私-相册”选项中，允许%@访问你的相册。",appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            hasAuthStatus = NO;
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            
            break;
        }
        default:
            break;
    }
    return hasAuthStatus;
}

/**
 用户访问相机权限判断
 
 @return 相机权限判断
 */
- (BOOL)authorizationCameraStatus {
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (appName == nil) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }

    BOOL hasAuthStatus = YES;
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined: {
            NSLog(@"未询问用户是否授权");
            break;
        }
        case PHAuthorizationStatusRestricted: {
            NSLog(@"未授权，例如家长控制");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"请在iPhone“设置-隐私-相机”选项中，允许%@访问你的相机。",appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            hasAuthStatus = NO;
            break;
        }
        case PHAuthorizationStatusDenied: {
            NSLog(@"未授权，用户拒绝造成的");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"请在iPhone“设置-隐私-相机”选项中，允许%@访问你的相机。",appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            hasAuthStatus = NO;
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            
            break;
        }
        default:
            break;
    }
    return hasAuthStatus;
}

/**
 清空数据
 */
- (void)clearData {
    [PhotoKitManager shareInstance].selectedAlbumMedias = [NSMutableDictionary dictionaryWithCapacity:0];
}

/**
 获取相册列表
 
 @return 相册列表
 */
- (NSMutableArray *)getAlbums {

    // 获取系统智能相册
    [self.photoAlbums removeAllObjects];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册 最近添加 最近删除
        if (result.count > 0 && ![collection.localizedTitle isEqualToString:@"Recently Deleted"] && ![collection.localizedTitle isEqualToString:@"Recently Added"]) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [[PhotoKitManager shareInstance] transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            albumModel.asset = result.lastObject;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
                [self.photoAlbums insertObject:albumModel atIndex:0];
            }else {
                [self.photoAlbums addObject:albumModel];
            }
        }
    }];
    
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [[PhotoKitManager shareInstance] transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            albumModel.asset = result.lastObject;
            [self.photoAlbums addObject:albumModel];
        }
    }];
    
    return self.photoAlbums;
}

/**
 根据需要显示的类型获取相册
 
 @param needMediaType needMediaType需要显示的资源类型
 @return 相册列表
 */
- (NSMutableArray *)getAlbumsNeedMediaType:(NeedShowMediaType)needMediaType {
    // 获取系统智能相册
    [self.photoAlbums removeAllObjects];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        if (needMediaType == NeedShowMediaTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
//            option.predicate = [NSPredicate predicateWithFormat:@"mediaSubtype == %ld", PHAssetMediaSubtypePhotoLive];
        } else if (needMediaType == NeedShowMediaTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册 最近添加 最近删除
        if (result.count > 0 && ![collection.localizedTitle isEqualToString:@"Recently Deleted"] && ![collection.localizedTitle isEqualToString:@"Recently Added"]) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [[PhotoKitManager shareInstance] transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            albumModel.asset = result.lastObject;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
                [self.photoAlbums insertObject:albumModel atIndex:0];
            }else {
                [self.photoAlbums addObject:albumModel];
            }
        }
    }];
    
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (needMediaType == NeedShowMediaTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
//            option.predicate = [NSPredicate predicateWithFormat:@"mediaSubtype == %ld", PHAssetMediaSubtypePhotoLive];
        } else if (needMediaType == NeedShowMediaTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [[PhotoKitManager shareInstance] transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            albumModel.asset = result.lastObject;
            [self.photoAlbums addObject:albumModel];
        }
    }];
    
    return self.photoAlbums;
}

/**
 判断相册是否是相机胶卷
 
 @param model model
 @return 是否为相机胶卷
 */
- (BOOL)isCameraRollOfAlbumModel:(AlbumModel *)model {
    BOOL isCameraRoll = NO;
    if ([@"Camera Roll" isEqualToString:model.albumName]) {
        isCameraRoll = YES;
    }
    return isCameraRoll;
}

/**
 根据类型和相册获取媒体资源
 
 @param albumModel 相册
 @param needMediaType 需要显示的媒体资源类型
 @return 媒体资源
 */
- (NSMutableArray *)getMediasOfAlbum:(AlbumModel *)albumModel needMediaType:(NeedShowMediaType)needMediaType {
    switch (needMediaType) {
        case NeedShowMediaTypeAll: {
            //所有资源
            return [[PhotoKitManager shareInstance] getMediasOfAlbum:albumModel];
            break;
        }
        case NeedShowMediaTypeGIF: {
            //GIF
            return [[PhotoKitManager shareInstance] getGifsOfAlbum:albumModel];
            break;
        }
        case NeedShowMediaTypeVideo: {
            //Video
            return [[PhotoKitManager shareInstance] getVideosOfAlbum:albumModel];
            break;
        }
        case NeedShowMediaTypePhotoLive: {
            //photoLive
            return [[PhotoKitManager shareInstance] getPhotoLivesOfAlbum:albumModel];
            break;
        }
        case NeedShowMediaTypePhoto: {
            //photo
            return [[PhotoKitManager shareInstance] getPhotosOfAlbum:albumModel];
            break;
        }
        default: {
            //默认为photo
            return [[PhotoKitManager shareInstance] getPhotosOfAlbum:albumModel];
            break;
        }
    }
}

/**
 根据相册获取媒体资源
 
 @param albumModel 相册model数据
 @return 相册中媒体资源
 */
- (NSMutableArray *)getMediasOfAlbum:(AlbumModel *)albumModel {
    __block NSMutableArray *medias = [NSMutableArray arrayWithCapacity:0];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.phasset = asset;
        
        //如果有Cloud缩略图
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                photoModel.mediaMode = MediaGifMode;
            } else if (@available(iOS 9.1, *)) {
                if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
                    photoModel.mediaMode = MediaPhotoliveMode;
                } else {
                    photoModel.mediaMode = MediaPhotoMode;
                }
            }
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.mediaMode = MediaVideoMode;
        }
        
        [medias addObject:photoModel];
    }];
    return medias;
}

/**
 根据相册获取所有照片
 
 @param albumModel 相册model数据
 @return 相册中所有照片
 */
- (NSMutableArray *)getPhotosOfAlbum:(AlbumModel *)albumModel {
    __block NSMutableArray *photos = [NSMutableArray arrayWithCapacity:0];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.phasset = asset;
        
        //如果有Cloud缩略图
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                photoModel.mediaMode = MediaGifMode;
            } else if (@available(iOS 9.1, *)) {
                if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
                    photoModel.mediaMode = MediaPhotoliveMode;
                } else {
                    photoModel.mediaMode = MediaPhotoMode;
                }
            }
            [photos addObject:photoModel];
        }
    }];
    return photos;
}

/**
 根据相册获取所有视频
 
 @param albumModel 相册model数据
 @return 相册中所有视频
 */
- (NSMutableArray *)getVideosOfAlbum:(AlbumModel *)albumModel {
    __block NSMutableArray *videos = [NSMutableArray arrayWithCapacity:0];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.phasset = asset;
        
        //如果有Cloud缩略图
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.mediaMode = MediaVideoMode;
            [videos addObject:photoModel];
        }
    }];
    return videos;
}

/**
 根据相册获取所有动图GIF
 
 @param albumModel 相册model数据
 @return 相册中所有动图GIF
 */
- (NSMutableArray *)getGifsOfAlbum:(AlbumModel *)albumModel {
    __block NSMutableArray *gifs = [NSMutableArray arrayWithCapacity:0];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.phasset = asset;
        
        //如果有Cloud缩略图
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                photoModel.mediaMode = MediaGifMode;
                [gifs addObject:photoModel];
            }
        }
    }];
    return gifs;
}

/**
 根据相册获取所有PhotoLives
 
 @param albumModel 相册model数据
 @return 相册中所有PhotoLives
 */
- (NSMutableArray *)getPhotoLivesOfAlbum:(AlbumModel *)albumModel {
    __block NSMutableArray *photoLives = [NSMutableArray arrayWithCapacity:0];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.phasset = asset;
        
        //如果有Cloud缩略图
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            if (@available(iOS 9.1, *)) {
                if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
                    photoModel.mediaMode = MediaPhotoliveMode;
                    [photoLives addObject:photoModel];
                }
            }
        }
    }];
    return photoLives;
}

/**
 根据PHAsset获取图片信息
 
 @param asset PHAsset
 @param targetSize 目标
 @param resultHandler block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)reqImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && resultHandler && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultHandler(result,info);
            });
        }else {
            //            PHImageRequestOptions networkAccessAllowed 要设置yes;
            //需要的话 调用下面从icloud获取
        }
    }];
}

/**
 根据PHAsset获取图片信息, 作为相册的缩略图
 
 @param asset PHAsset
 @param targetSize 目标
 @param resultHandler block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)reqAblumImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *result, NSDictionary *info))resultHandler {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && resultHandler && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultHandler(result,info);
            });
        }else {
            //            PHImageRequestOptions networkAccessAllowed 要设置yes;
            //需要的话 调用下面从icloud获取
        }
    }];
}

/**
 根据PHAsset获取AVAsset

 @param asset PHAsset
 @param completion block
 @param failure block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset completion:(void(^)(AVAsset *asset))completion failure:(void(^)(void))failure {
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(asset);
                }
            });
        }else {
            if(failure) {
                failure();
            }
            //需要的话 调用下面从icloud获取
        }
    }];
}


/**
 根据PHAsset获取PlayerItem
 
 @param asset PHAsset
 @param completion block
 @param failure block
 @return 返回iCloud PHImageRequestID
 */
- (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset completion:(void(^)(AVPlayerItem *playerItem))completion failure:(void(^)(void))failure {
 
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && playerItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(playerItem);
                }
            });
        }else {
            if(failure) {
                failure();
            }
            //需要的话 调用下面从icloud获取
        }
    }];
}

/**
 根据PHAsset获取AVAsset
 
 @param asset PHAsset
 @return AVAsset
 */
- (AVAsset *)getAVAssetForVideo:(PHAsset *)asset {
    __block AVAsset *avasset;
    [[PhotoKitManager shareInstance] requestAVAssetForVideo:asset completion:^(AVAsset *asset) {
        avasset = asset;
    } failure:^{
        
    }];
    return avasset;
}

/**
 根据PHAsset获取AVPlayerItem
 
 @param asset PHAsset
 @return AVAsset
 */
- (AVPlayerItem *)getPlayerItemForVideo:(PHAsset *)asset {
    __block AVPlayerItem *avPlayerItem;
    [[PhotoKitManager shareInstance] requestPlayerItemForVideo:asset completion:^(AVPlayerItem *playerItem) {
        avPlayerItem = playerItem;
    } failure:^{
        
    }];
    return avPlayerItem;
}

/**
 相册名称转换，转换成中文

 @param englishName 英文
 @return 中文
 */
- (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"]){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"]){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"]){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"]){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"]){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"]){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"]){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"]){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"]){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"]){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}

/**
 是否包括在已经选中的列表中了
 
 @param model model
 @return 是否在 YES OR NO
 */
- (BOOL)containMediaInSelectedList:(PhotoModel *)model {
    
    NSString *selectedIdentifier = [NSString stringWithFormat:@"%@",model.identifier];
    PhotoModel *aModel = [[PhotoKitManager shareInstance].selectedAlbumMedias objectForKey:selectedIdentifier];
    if (aModel && aModel.phasset) {
        return YES;
    }
    
    return NO;
}

/**
 找出 identifier标示的下标
 
 @param identifier 唯一标识
 @return 下标Index
 */
- (NSInteger)indexOfPhotoInSelectedList:(NSString *)identifier {
    NSInteger index = NSNotFound;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (identifier && [identifier isEqualToString:model.phasset.localIdentifier]) {
            index = [[[PhotoKitManager shareInstance].selectedAlbumMedias allValues] indexOfObject:model];
            break;
        }
    }
    return index;
}

/**
 选中的媒体资源是否包含视频
 
 @return YES oR NO
 */
- (BOOL)hasVideoInSelectedList {
    BOOL hasVideo = NO;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (model.mediaMode == MediaVideoMode) {
            hasVideo = YES;
            break;
        }
    }
    return hasVideo;
}

/**
 选中的媒体资源是否包含tup
 
 @return YES oR NO
 */
- (BOOL)hasPhotoInSelectedList {
    BOOL hasPhoto = NO;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (model.mediaMode == MediaPhotoMode) {
            hasPhoto = YES;
            break;
        }
    }
    return hasPhoto;
}

/**
 选中的媒体资源是否包含livePhoto
 
 @return YES oR NO
 */
- (BOOL)hasPhotoLiveInSelectedList {
    BOOL hasPhotoLive = NO;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (model.mediaMode == MediaPhotoliveMode) {
            hasPhotoLive = YES;
            break;
        }
    }
    return hasPhotoLive;
}

/**
 选中的媒体资源是否包含GIF
 
 @return YES oR NO
 */
- (BOOL)hasGIFInSelectedList {
    BOOL hasGIF = NO;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (model.mediaMode == MediaGifMode) {
            hasGIF = YES;
            break;
        }
    }
    return hasGIF;
}

/**
 选中的媒体资源是否包含非视频 媒体资源
 
 @return YES oR NO
 */
- (BOOL)hasNotVideoMediaInSelectedList {
    BOOL hasNotVideo = NO;
    for (PhotoModel *model in [[PhotoKitManager shareInstance].selectedAlbumMedias allValues]) {
        if (model.mediaMode == MediaGifMode || model.mediaMode == MediaPhotoliveMode || model.mediaMode == MediaPhotoMode) {
            hasNotVideo = YES;
            break;
        }
    }
    return hasNotVideo;
}


/**
 将媒体资源model添加到选中列表中

 @param model model model
 @return 最后model，如果在选中列表了，则返回YES
 */
- (BOOL)addSelectedPhotoModel:(PhotoModel *)model {
    //视频限制数量和图片不一样
    BOOL hasVideo = NO;
    if (model.mediaMode == MediaVideoMode && [[PhotoKitManager shareInstance] hasNotVideoMediaInSelectedList]) {
        //如果当前点击要选中视频，之前已经有非视频了，则不能选中
        [SVProgressHUD showErrorWithStatus:kCantSelectedPhotoVideoTips];
        return NO;
    } else {
        if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
            //如果当前点击要选中图片，之前已经有视频了，则不能选中
            hasVideo = YES;
            [SVProgressHUD showErrorWithStatus:kCantSelectedPhotoVideoTips];
            return NO;
        }
    }
    
    NSInteger maxMediaCount = (hasVideo?[PhotoKitManager shareInstance].maxVideoSelectedCount:[PhotoKitManager shareInstance].maxPhotoSelectedCount);
    
    NSString *selectedIdentifier = [NSString stringWithFormat:@"%@",model.identifier];
    
    PhotoModel *aModel = [[PhotoKitManager shareInstance].selectedAlbumMedias objectForKey:selectedIdentifier];
    //是否已经选中该图片，之前已经选中了该图片
    if (aModel && aModel.phasset) {
        //如果现在又取消选中了，则将该图片移除
        [[PhotoKitManager shareInstance].selectedAlbumMedias removeObjectForKey:selectedIdentifier];
    } else {
        if ([PhotoKitManager shareInstance].selectedAlbumMedias.allValues.count < maxMediaCount) {
            [[PhotoKitManager shareInstance].selectedAlbumMedias setObject:aModel forKey:selectedIdentifier];
        }
    }
    
    return [[PhotoKitManager shareInstance] containMediaInSelectedList:model];
}

@end
