//
//  PhotoPreviewPresenter.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoPreviewPresenter.h"
#import "PhotoKitDefine.h"
//#import "ImageToVideoViewController.h"

static NSString *kPhotoPreviewCellIdentifier = @"PhotoPreviewCollectionViewCell";

@interface PhotoPreviewPresenter ()<PhotoPreviewCollectionViewCellDelegate>

/**
 选中的相册，默认去除video
 */
@property (nonatomic, strong) NSMutableArray *currentAlbumPhotoModels;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

/**
 之前进入页面选中过的媒体资源数组
 */
@property (nonatomic, strong) NSMutableArray *tmpSelectedPhotoModels;

@end

@implementation PhotoPreviewPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentAlbumPhotoModels = [NSMutableArray arrayWithCapacity:0];
        self.tmpSelectedPhotoModels = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

/**
 加载显示的图片并且滚动到选中的图片的位置
 */
- (void)loadPhotoPreviewItems {
    //滚动到选中的图片位置
    self.tmpSelectedPhotoModels = [NSMutableArray arrayWithArray:[PhotoKitManager shareInstance].selectedAlbumMedias.allValues];
    self.photoPreviewView.collectionView.scrollEnabled = YES;
    self.photoPreviewView.selectorNavBar.selectButton.enabled = YES;
    self.photoPreviewView.selectorNavBar.backButton.enabled = YES;
    
    NSIndexPath *selectedIndexPath;
    if (self.isShowSelected) {
        [self.photoPreviewView.collectionView reloadData];
        
        NSInteger index = 0;
        for (PhotoModel *model in [PhotoKitManager shareInstance].selectedAlbumMedias.allValues) {
            if (self.currentPhotoIdentifier && [self.currentPhotoIdentifier isEqualToString:model.phasset.localIdentifier]) {
                index = [[PhotoKitManager shareInstance].selectedAlbumMedias.allValues indexOfObject:model];
                break;
            }
        }
        
        if ([PhotoKitManager shareInstance].selectedAlbumMedias && [PhotoKitManager shareInstance].selectedAlbumMedias.count > 0) {
            selectedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        }
    } else {
        
        self.currentAlbumPhotoModels = [[PhotoKitManager shareInstance] getPhotosOfAlbum:[PhotoKitManager shareInstance].currentAlbumModel];
        [self.photoPreviewView.collectionView reloadData];
        NSInteger index = 0;
        NSLog(@"currentPhotoIdentifier:%@",self.currentPhotoIdentifier);
        for (PhotoModel *model in self.currentAlbumPhotoModels) {
            NSLog(@"model.identifier:%@",self.currentPhotoIdentifier);
            if (self.currentPhotoIdentifier && [self.currentPhotoIdentifier isEqualToString:model.phasset.localIdentifier]) {
                index = [self.currentAlbumPhotoModels indexOfObject:model];
                break;
            }
        }
                
        if (self.currentAlbumPhotoModels && self.currentAlbumPhotoModels.count > 0) {
            selectedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        }
    }
    
    if (selectedIndexPath) {
        self.selectedIndexPath = selectedIndexPath;
    }
}

/**
 滚动到选中的图片的位置
 */
- (void)scrollSelectedItem {
    if (self.selectedIndexPath) {
        [self.photoPreviewView.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    //检测model是否被选中，被选中则显示选中标识
    NSInteger index = (NSInteger)self.photoPreviewView.collectionView.contentOffset.x/kPhotoScreenWidth;
    PhotoModel *photoModel = [self photoModelAtIndex:index];
    [self setNavBarSelectionModel:photoModel animated:NO];
}

/**
 注册cell
 */
- (void)registerCollectionCell {
    [self.photoPreviewView.collectionView registerClass:[PhotoPreviewCollectionViewCell class] forCellWithReuseIdentifier:kPhotoPreviewCellIdentifier];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kPhotoScreenWidth, kPhotoScreenHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isShowSelected) {
        return self.tmpSelectedPhotoModels.count;
    } else {
        return self.currentAlbumPhotoModels.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPreviewCollectionViewCell *cell = (PhotoPreviewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPreviewCellIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    PhotoModel *photoModel;
    if (self.isShowSelected) {
        photoModel = [self.tmpSelectedPhotoModels objectAtIndex:index];
    } else {
        photoModel = [self.currentAlbumPhotoModels objectAtIndex:index];
    }
    photoModel.selected = [[PhotoKitManager shareInstance] containMediaInSelectedList:photoModel];
    cell.delegate = self;
    cell.photoModel = photoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index =  (NSInteger)collectionView.contentOffset.x/kPhotoScreenWidth;
    PhotoModel *photoModel = [self photoModelAtIndex:index];
    [self setNavBarSelectionModel:photoModel animated:NO];
}

- (PhotoModel *)photoModelAtIndex:(NSInteger)index {
    PhotoModel *photo = nil;
    if (self.isShowSelected) {
        if (index < 0 || index >= self.tmpSelectedPhotoModels.count) {
            return nil;
        }
        photo = (PhotoModel *)self.tmpSelectedPhotoModels[index];
    } else {
        if (index < 0 || index >= self.currentAlbumPhotoModels.count) {
            return nil;
        }
        photo = [self.currentAlbumPhotoModels objectAtIndex:index];
    }
    return photo;
}

#pragma mark - DFDisplayCollectionCellDelegate
- (void)displayCollectionCellPhotoViewTapped:(PhotoPreviewCollectionViewCell *)cell {
    self.photoPreviewView.barHidden = !self.photoPreviewView.isBarHidden;
}

- (void)setNavBarSelectionModel:(PhotoModel *)model animated:(BOOL)animated {
    BOOL hasContainPhoto = [[PhotoKitManager shareInstance] containMediaInSelectedList:model];
    [self.photoPreviewView.selectorNavBar setCurrentSelected:hasContainPhoto animated:animated];
    
    [self.photoPreviewView.selectorBar setSelectedBarCount:[PhotoKitManager shareInstance].selectedAlbumMedias.allValues.count];
}

#pragma - PhotoPreviewNavBarDelegate
/**
 点击取消
 */
- (void)back {
    if (self.popControllerHandler) {
        self.popControllerHandler(nil);
    }
}

/**
 点击选择按钮标识
 */
- (void)handleSelectDidClicked {
    NSInteger index = (NSInteger)self.photoPreviewView.collectionView.contentOffset.x/kPhotoScreenWidth;
    PhotoModel *photoModel = [self photoModelAtIndex:index];
    if (photoModel == nil) {
        //找不到，直接返回
        return;
    }
    
    //视频限制数量和图片不一样
    if (photoModel.mediaMode == MediaVideoMode) {
        if ([[PhotoKitManager shareInstance] hasNotVideoMediaInSelectedList]) {
            //如果当前点击要选中视频，之前已经有非视频了，则不能选中
            [SVProgressHUD showErrorWithStatus:kCantSelectedPhotoVideoTips];
            return;
        }
    } else {
        if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
            //如果当前点击要选中图片，之前已经有视频了，则不能选中
            [SVProgressHUD showErrorWithStatus:kCantSelectedPhotoVideoTips];
            return;
        }
    }
    
    BOOL hasVideo = NO;
    if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
        //如果当前点击要选中图片，之前已经有视频了，则不能选中
        hasVideo = YES;
    }
    
    NSInteger maxMediaCount = (hasVideo?[PhotoKitManager shareInstance].maxVideoSelectedCount:[PhotoKitManager shareInstance].maxPhotoSelectedCount);
    BOOL hasContainPhoto = [[PhotoKitManager shareInstance] containMediaInSelectedList:photoModel];
    if (!hasContainPhoto) {
        //如果不存在选中列表，则添加到选中列表中
        if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count >= maxMediaCount) {
            [SVProgressHUD showErrorWithStatus:(hasVideo?kMaxSelectedVideoTips:kMaxSelectedPhotoTips)];
        } else {
            [[PhotoKitManager shareInstance].selectedAlbumMedias setObject:photoModel forKey:photoModel.phasset.localIdentifier];
        }
    } else {
        [[PhotoKitManager shareInstance].selectedAlbumMedias removeObjectForKey:photoModel.phasset.localIdentifier];
    }
    
    [self setNavBarSelectionModel:photoModel animated:YES];
}

#pragma - SelectorMediaBarDelegate
/**
 预览按钮点击
 */
- (void)previewButtonDidClicked {
    
}

/**
 完成/下一步按钮点击
 */
- (void)completeButtonDidClicked {
    
    NSURL *photoURL = [NSURL URLWithString:@"https://p9.pstatp.com/large/8ac00007b3e925f20290.jpg"];//
    NSURL *videoURL = [NSURL URLWithString:@"http://o7sfi83by.bkt.clouddn.com/kkela_20180607113655.mov"];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            //标识保存到系统相册中的标识
            __block NSString *localIdentifier;
            
            //首先获取相册的集合
            PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
            //对获取到集合进行遍历
            [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PHAssetCollection *assetCollection = obj;
                //folderName是我们写入照片的相册
                //        if ([assetCollection.localizedTitle isEqualToString:_folderName])  {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //请求创建一个Asset
//                    PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];

                    PHAssetCreationRequest * assetRequest = [PHAssetCreationRequest creationRequestForAsset];
                    [assetRequest addResourceWithType:PHAssetResourceTypePhoto data:photoData options:nil];
                    [assetRequest addResourceWithType:PHAssetResourceTypeAdjustmentBasePairedVideo data:videoData options:nil];

                    //请求编辑相册
                    PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    //为Asset创建一个占位符，放到相册编辑请求中
                    PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                    //相册中添加视频
                    [collectonRequest addAssets:@[placeHolder]];
                    
                    localIdentifier = placeHolder.localIdentifier;
                } completionHandler:^(BOOL success, NSError *error) {
                    if (success) {
                        NSLog(@"保存视频成功!");
                    } else {
                        NSLog(@"保存视频失败:%@", error);
                    }
                }];
                //        }
                *stop = YES;
            }];
        });
    });

    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges: ^{
        if (@available(iOS 9.0, *)) {
            PHAssetCreationRequest * request = [PHAssetCreationRequest creationRequestForAsset];
            [request addResourceWithType:PHAssetResourceTypePhoto fileURL: photoURL options: nil];
            [request addResourceWithType:PHAssetResourceTypeFullSizeVideo fileURL: videoURL options: nil];
        } else {
            // Fallback on earlier versions
        }
    } completionHandler: ^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"LivePhotos 已经保存至相册!");
        } else {
            NSLog(@"error: %@", error);
        }
    }];

//    ImageToVideoViewController *imageVideo = [[ImageToVideoViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVideo];
//    if (self.presentController) {
//        self.presentController(nav, nil);
//    }
}

/**
 数量按钮点击
 */
- (void)numberButtonDidClicked {
    
}

#pragma - SETTER/GETTER
- (PhotoPreviewView *)photoPreviewView {
    if (!_photoPreviewView) {
        _photoPreviewView = [[PhotoPreviewView alloc] initWithFrame:CGRectZero];
    }
    return _photoPreviewView;
}

@end
