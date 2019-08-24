//
//  PhotoSelectorPresenter.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoSelectorPresenter.h"
#import "TakePhotoCollectionViewCell.h"
#import "PhotoSelectorCollectionViewCell.h"
#import "PhotoKitManager.h"
#import "PhotoNavMenuView.h"
#import "PhotoNavMenuView.h"

static NSString *kPhotoCameraCellIdentifier = @"TakePhotoCollectionViewCell";
static NSString *kPhotoCellIdentifier = @"PhotoSelectorCollectionViewCell";

@interface PhotoSelectorPresenter ()<TakePhotoCollectionViewCellDelegate,PhotoSelectorCollectionViewCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PhotoNavMenuViewDelegate>

/**
 当前选中的相册，默认为相机胶卷
 */
@property (nonatomic, strong) AlbumModel *currentAlbumModel;

/**
 是否包含拍照按钮，如果是相机胶卷，则显示拍照按钮功能
 */
@property (nonatomic, assign) BOOL hasCamera;

/**
 当前相册包含的媒体文件
 */
@property (nonatomic, strong) NSMutableArray *currentAlbumMedias; //当前相册

/**
 超出数量，或者规定类型，不能再选中，默认为YES
 */
@property(nonatomic, readwrite, getter=isSelectable) BOOL selectable;

/**
 导航相册展开界面，展示可以切换的相册控件
 */
@property(nonatomic, strong) PhotoNavMenuView *menuView;

@end

@implementation PhotoSelectorPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.column = 4;
        self.selectable = YES;
        self.hasCamera = YES;
        self.currentAlbumModel = [[AlbumModel alloc] init];
        self.currentAlbumMedias = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

/**
 注册cell
 */
- (void)registerCollectionCell {
    [self.photoSelectorView.collectionView registerClass:[TakePhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCameraCellIdentifier];
    [self.photoSelectorView.collectionView registerClass:[PhotoSelectorCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
}

/**
 加载相机胶卷
 */
- (void)loadCameraMedias {
    
    NSMutableArray *albums = [[PhotoKitManager shareInstance] getAlbumsNeedMediaType:self.needMediaType];
    if (albums.count > 0) {
        AlbumModel *albumModel = [albums objectAtIndex:0];
        self.currentAlbumModel = albumModel;
        self.currentAlbumMedias = [[PhotoKitManager shareInstance] getMediasOfAlbum:self.currentAlbumModel needMediaType:self.needMediaType];
    }
    
    self.hasCamera = [[PhotoKitManager shareInstance] isCameraRollOfAlbumModel:self.currentAlbumModel];
    
    [self.photoSelectorView.collectionView reloadData];
    
    [PhotoKitManager shareInstance].currentAlbumModel = self.currentAlbumModel;
    [self updateNavMenuButton];
}

/**
 重新刷新界面
 */
- (void)reloadViewSelectedMedia {
    self.selectable = YES;
    BOOL hasVideo = NO;
    if ([[PhotoKitManager shareInstance] hasVideoInSelectedList]) {
        //如果当前点击要选中图片，之前已经有视频了，则不能选中
        hasVideo = YES;
    }

    NSInteger maxMediaCount = (hasVideo?[PhotoKitManager shareInstance].maxVideoSelectedCount:[PhotoKitManager shareInstance].maxPhotoSelectedCount);
    if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count >= maxMediaCount) {
        self.selectable = NO;
    }
    
    //如果没有选中，则预览按钮不能点击
    self.photoSelectorView.toolBar.previewButton.enabled = NO;
    if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count > 0) {
        self.photoSelectorView.toolBar.previewButton.enabled = YES;
    }
    [self.photoSelectorView.toolBar setSelectedBarCount:[[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count];
    
    if ([PhotoKitManager shareInstance].maxPhotoSelectedCount == 1) {
        //如果图片限制数量为1时候，则需要“完成”按钮，否则显示“下一步”
        [self.photoSelectorView.toolBar.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [self.photoSelectorView.toolBar.completeButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    [self.photoSelectorView.collectionView reloadData];
}

/**
 更新导航按钮
 */
- (void)updateNavMenuButton {
    if (self.presenterHandler && self.currentAlbumModel) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.currentAlbumModel.albumNameCh, NavMenuButtonNameKey,
                              [NSString stringWithFormat:@"%ld",(long)PresenterHandlerUpdateNav], PresenterHandlerTypeKey,
                              @"0", NavMenuButtonActiveKey
                              , nil];
        self.presenterHandler(data);
    }
}

/**
 预览图片

 @param identifier 选中图片的标示
 @param previewSelected 是否预览
 */
- (void)pushPhotoPreview:(NSString *)identifier previewSelected:(BOOL)previewSelected{
    if (self.presenterHandler && self.currentAlbumModel) {
        
        BOOL isMediaVideoType = NO;
        PhotoModel *selectedPhotoModel;
        for (PhotoModel *model in self.currentAlbumMedias) {
            NSLog(@"model.identifier:%@",identifier);
            if (identifier && [identifier isEqualToString:model.phasset.localIdentifier]) {
                selectedPhotoModel = model;
                if (selectedPhotoModel.mediaMode == MediaVideoMode) {
                    isMediaVideoType = YES;
                }
                break;
            }
        }
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%ld",(long)PresenterHandlerPushPreview], PresenterHandlerTypeKey,
                              [NSString stringWithFormat:@"%@",identifier], PhotoPreviewIDKey,
                              [NSString stringWithFormat:@"%@",previewSelected?@"1":@"0"], PhotoPreviewSelectedKey,
                              [NSString stringWithFormat:@"%ld",isMediaVideoType?(long)PreviewMediaTypeVideo:(long)PreviewMediaTypePhoto], PreviewMediaTypeKey
                              , nil];
        self.presenterHandler(data);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (CGRectGetWidth(collectionView.bounds) - (self.column + 1) * 4.0) / self.column;
    return CGSizeMake(w, w);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //如果是相机胶卷，则显示拍照按钮，否则不显示拍照按钮
    return self.currentAlbumMedias.count + (self.hasCamera?1:0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    //如果是相机胶卷，第一个位置显示拍照按钮
    if (self.hasCamera && index == 0) {
        TakePhotoCollectionViewCell * cell = (TakePhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCameraCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    NSInteger mediaIndex = self.hasCamera?(index - 1):index;
    PhotoModel *photoModel = [self.currentAlbumMedias objectAtIndex:mediaIndex];
    
    //显示相册媒体资源
    PhotoSelectorCollectionViewCell *cell = (PhotoSelectorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.photoModel = photoModel;
    cell.selectable = self.selectable;
    cell.delegate = self;
    cell.tag = mediaIndex;

    NSString *selectedIdentifier = [NSString stringWithFormat:@"%@",photoModel.identifier];
    PhotoModel *aModel = [[PhotoKitManager shareInstance].selectedAlbumMedias objectForKey:selectedIdentifier];
    //是否已经选中该图片，之前已经选中了该图片
    BOOL hasSelected = NO;
    if (aModel && aModel.phasset) {
        hasSelected = YES;
    }
    [cell setMarkSelected:hasSelected animated:NO];

    return cell;
}

#pragma - TakePhotoCollectionViewCellDelegate
- (void)takePhotoCellButtonDidClicked:(TakePhotoCollectionViewCell *)cell {
    [self fromCamera];
}

- (void)fromCamera {
    BOOL hasAuth = [[PhotoKitManager shareInstance] authorizationCameraStatus];
    if (!hasAuth) {
        return;
    }
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        self.presentController(imagePicker,nil);
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的设备不支持拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image){
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        //保存到相册
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"error=%@", error);
    }
    //牌照保存到相册，成功后重新加载一遍
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadCameraMedias];
    });
}

#pragma mark - PhotoSelectorCollectionViewCellDelegate 点击collectionView
/**
 点击选择当前标记cell
 
 @param cell 当前cell
 */
- (void)photoSelectorMarkDidClicked:(PhotoSelectorCollectionViewCell *)cell {
    PhotoModel *cellPhotoModel = [self.currentAlbumMedias objectAtIndex:cell.tag];
    
    //视频限制数量和图片不一样
    if (cellPhotoModel.mediaMode == MediaVideoMode) {
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
    
    NSString *selectedIdentifier = [NSString stringWithFormat:@"%@",cellPhotoModel.identifier];
    
    PhotoModel *aModel = [[PhotoKitManager shareInstance].selectedAlbumMedias objectForKey:selectedIdentifier];
    //是否已经选中该图片，之前已经选中了该图片
    if (aModel && aModel.phasset) {
        //如果现在又取消选中了，则将该图片移除
        [[PhotoKitManager shareInstance].selectedAlbumMedias removeObjectForKey:selectedIdentifier];
        cellPhotoModel.selected = NO;
    } else {
        if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count >= maxMediaCount) {
            [SVProgressHUD showErrorWithStatus:(hasVideo?kMaxSelectedVideoTips:kMaxSelectedPhotoTips)];
        } else {
            [[PhotoKitManager shareInstance].selectedAlbumMedias setObject:cell.photoModel forKey:selectedIdentifier];
            cellPhotoModel.selected = YES;
        }
    }
    
    [cell setMarkSelected:cellPhotoModel.selected animated:YES];
    
    self.selectable = YES;
    if ([[PhotoKitManager shareInstance].selectedAlbumMedias allValues].count >= maxMediaCount) {
        self.selectable = NO;
        [self reloadVisibleCells];
    }
    
    if (!cellPhotoModel.selected) {
        [self reloadVisibleCells];
    }
    
    [self.photoSelectorView.toolBar setSelectedBarCount:[PhotoKitManager shareInstance].selectedAlbumMedias.allValues.count];
}

/**
 点击选择当前cell 进入预览页面
 
 @param cell 当前cell
 */
- (void)photoSelectorPreviewDidClicked:(PhotoSelectorCollectionViewCell *)cell {
    if (cell.photoModel.phasset) {        
        NSString *localIdentifier = cell.photoModel.phasset.localIdentifier;
        [self pushPhotoPreview:localIdentifier previewSelected:NO];
    }
}

/**
 重新加载可用的
 */
- (void)reloadVisibleCells {
    NSArray *cells = self.photoSelectorView.collectionView.visibleCells;
    for (UICollectionViewCell *cell in cells) {
        if ([cell isKindOfClass:[PhotoSelectorCollectionViewCell class]]) {
            PhotoSelectorCollectionViewCell *selectorCell = (PhotoSelectorCollectionViewCell *)cell;
            PhotoModel *photoModel = [self.currentAlbumMedias objectAtIndex:cell.tag];
            NSString *selectedIdentifier = [NSString stringWithFormat:@"%@",photoModel.identifier];
            PhotoModel *aModel = [[PhotoKitManager shareInstance].selectedAlbumMedias objectForKey:selectedIdentifier];
            if (aModel && aModel.phasset) {
                photoModel.selected = YES;
            } else {
                photoModel.selected = NO;
            }
            selectorCell.photoModel = photoModel;
            selectorCell.selectable = self.selectable;
            continue;
        }
    }
}

#pragma mark - SelectorMediaBarDelegate
/**
 点击预览按钮
 */
- (void)previewButtonDidClicked {
    if ([PhotoKitManager shareInstance].selectedAlbumMedias && [PhotoKitManager shareInstance].selectedAlbumMedias.count > 0) {
        NSString *localIdentifier = [[[PhotoKitManager shareInstance].selectedAlbumMedias allKeys] firstObject];
        [self pushPhotoPreview:localIdentifier previewSelected:YES];
    }
}

/**
 点击完成、下一步按钮
 */
- (void)completeButtonDidClicked {
    
}

/**
 点击数量按钮
 */
- (void)numberButtonDidClicked {
    
}

#pragma mark - PhotoNavMenuViewDelegate相关操作
- (void)selectedMenuItemDidClicked:(PhotoNavMenuItem *)item {
    self.currentAlbumModel = item.albumModel;
    self.hasCamera = [[PhotoKitManager shareInstance] isCameraRollOfAlbumModel:self.currentAlbumModel];
    self.currentAlbumMedias = [[PhotoKitManager shareInstance] getMediasOfAlbum:self.currentAlbumModel needMediaType:self.needMediaType];
    [self.photoSelectorView.collectionView reloadData];
    
    [PhotoKitManager shareInstance].currentAlbumModel = self.currentAlbumModel;
    [self updateNavMenuButton];
}

#pragma mark - 导航按钮相关操作
/**
 点击导航取消按钮操作
 */
- (void)leftNavItemClicked {
    //点击取消，清空选中
    [[PhotoKitManager shareInstance] clearData];
    
    if (self.dismissControllerHandler) {
        self.dismissControllerHandler(nil);
    }
}

/**
 点击导航titleView切换相册

 @param showNavMenu 是否隐藏与消失 YES，为显示 NO为隐藏
 */
- (void)navMenuItemClicked:(BOOL)showNavMenu {
    NSMutableArray *albums = [[PhotoKitManager shareInstance] getAlbumsNeedMediaType:self.needMediaType];
    
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:0];
    for (AlbumModel *model in albums) {
        PhotoNavMenuItem *menuItem = [[PhotoNavMenuItem alloc] init];
        menuItem.albumModel = model;
        
        menuItem.selected = NO;
        if (model.asset.localIdentifier && [model.asset.localIdentifier isEqualToString:self.currentAlbumModel.asset.localIdentifier]) {
            menuItem.selected = YES;
        }
        
        [menuItems addObject:menuItem];
    }
    
    if (!self.menuView) {
        self.menuView = [[PhotoNavMenuView alloc] initWithOringinFrame:(kPhotoStatusBarHeight + 44.0) items:menuItems superView:self.photoSelectorView];
    }
    
    self.menuView.menuItems = menuItems;
    self.menuView.delegate = self;
    
    if (showNavMenu) {
        [self.menuView show];
    } else {
        [self.menuView dismiss];
    }
}

#pragma - SETTER/GETTER
- (PhotoSelectorView *)photoSelectorView {
    if (!_photoSelectorView) {
        _photoSelectorView = [[PhotoSelectorView alloc] initWithFrame:CGRectZero];
    }
    return _photoSelectorView;
}

@end
