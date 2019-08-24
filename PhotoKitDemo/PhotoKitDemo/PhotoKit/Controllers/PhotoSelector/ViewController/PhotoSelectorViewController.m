//
//  PhotoSelectorViewController.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoSelectorViewController.h"
#import "PhotoSelectorPresenter.h"
#import "PhotoPreviewViewController.h"
#import "VideoPreviewViewController.h"

@interface PhotoSelectorViewController ()

@property (nonatomic, strong) PhotoSelectorView *photoSelectorView;
@property (nonatomic, strong) PhotoSelectorPresenter *photoSelectorPresenter;

@end

@implementation PhotoSelectorViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needMaxPhotoCount = 6; //图片选中的数量，默认最大限制6张
        self.needMaxVideoCount = 1; //视频选中的数量，默认最大1个视频
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view = self.photoSelectorView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.photoSelectorPresenter reloadViewSelectedMedia];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    //默认限制图片选中的数量，和视频数量
    [PhotoKitManager shareInstance].maxPhotoSelectedCount = self.needMaxPhotoCount;
    [PhotoKitManager shareInstance].maxVideoSelectedCount = self.needMaxVideoCount;

    [self configureNavigationBar];
    [self configuration];
    [self.photoSelectorPresenter loadCameraMedias];
}

- (void)configuration {
    self.photoSelectorPresenter.photoSelectorView = self.photoSelectorView;
    self.photoSelectorPresenter.needMediaType = self.needMediaType;
    self.photoSelectorView.delegate = self.photoSelectorPresenter;
    [self.photoSelectorPresenter registerCollectionCell];
    
    __weak typeof(self) weakSelf = self;
    self.photoSelectorPresenter.popControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.photoSelectorPresenter.dismissControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.photoSelectorPresenter.presentController = ^(UIViewController *controller, id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf presentViewController:controller animated:YES completion:nil];
    };
    
    //present通知Controller作出相应的处理
    self.photoSelectorPresenter.presenterHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf initNavTitleBarButton:data];
        [strongSelf photoPreview:data];
    };
}

#pragma mark - 配置configureNavigationBar
- (void)configureNavigationBar {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selectLeftAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //导航titleView
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, 44.0);
    NavMenuButton *barbutton = [[NavMenuButton alloc]initWithFrame:frame];
    barbutton.backgroundColor = [UIColor clearColor];
    [barbutton addTarget:self action:@selector(navMenuTitleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barbutton sizeToFit];
    self.navigationItem.titleView = barbutton;
}

- (void)selectLeftAction {
    [self.photoSelectorPresenter leftNavItemClicked];
}

- (void)initNavTitleBarButton:(id)data {
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *infoDict = (NSDictionary *)data;
        NSString *handleType = infoDict[PresenterHandlerTypeKey];
        if (handleType && handleType.integerValue == PresenterHandlerUpdateNav) {
            NavMenuButton *barbutton = (NavMenuButton *)self.navigationItem.titleView;
            barbutton.title = infoDict[NavMenuButtonNameKey];
            barbutton.active = [infoDict[NavMenuButtonActiveKey] boolValue];
        }
    }
}

- (void)navMenuTitleButtonClicked:(NavMenuButton *)barbutton {
    [self.photoSelectorPresenter navMenuItemClicked:!barbutton.active];
    barbutton.active = !barbutton.active;
}

/**
 预览图片

 @param identifier 唯一标示
 */

/**
 预览图片

 @param data 相关参数
 */
- (void)photoPreview:(NSData *)data {
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *infoDict = (NSDictionary *)data;
        NSString *handleType = infoDict[PresenterHandlerTypeKey];
        NSString *identifier = infoDict[PhotoPreviewIDKey];
        NSString *isSelected = infoDict[PhotoPreviewSelectedKey];
        NSString *mediaType = infoDict[PreviewMediaTypeKey];
        if (handleType && handleType.integerValue == PresenterHandlerPushPreview) {
            
            if (mediaType.integerValue == PreviewMediaTypeVideo) {
                VideoPreviewViewController *videoPreview = [[VideoPreviewViewController alloc] init];
                videoPreview.currentVideoIdentifier = identifier;
                [self.navigationController pushViewController:videoPreview animated:YES];
                return;
            }

            PhotoPreviewViewController *photoPreview = [[PhotoPreviewViewController alloc] init];
            photoPreview.currentPhotoIdentifier = identifier;
            photoPreview.isShowSelected = [isSelected boolValue];
            [self.navigationController pushViewController:photoPreview animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - SETTER/GETTER
- (PhotoSelectorView *)photoSelectorView {
    if (!_photoSelectorView) {
        _photoSelectorView = [[PhotoSelectorView alloc] initWithFrame:CGRectZero];
    }
    return _photoSelectorView;
}

- (PhotoSelectorPresenter *)photoSelectorPresenter {
    if (!_photoSelectorPresenter) {
        _photoSelectorPresenter = [[PhotoSelectorPresenter alloc] init];
    }
    return _photoSelectorPresenter;
}

@end
