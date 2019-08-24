//
//  PhotoPreviewViewController.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "PhotoPreviewPresenter.h"

@interface PhotoPreviewViewController ()

@property (nonatomic, strong) PhotoPreviewView *photoPreviewView;
@property (nonatomic, strong) PhotoPreviewPresenter *photoPreviewPresenter;

@end

@implementation PhotoPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)loadView {
    [super loadView];
    self.view = self.photoPreviewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configuration];
    [self.photoPreviewPresenter loadPhotoPreviewItems];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.photoPreviewPresenter scrollSelectedItem];
}

- (void)configuration {
    self.photoPreviewPresenter.currentPhotoIdentifier = self.currentPhotoIdentifier;
    self.photoPreviewPresenter.isShowSelected = self.isShowSelected;
    self.photoPreviewPresenter.photoPreviewView = self.photoPreviewView;
    self.photoPreviewView.delegate = self.photoPreviewPresenter;
    [self.photoPreviewPresenter registerCollectionCell];
    
    __weak typeof(self) weakSelf = self;
    self.photoPreviewPresenter.popControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.photoPreviewPresenter.dismissControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.photoPreviewPresenter.presentController = ^(UIViewController *controller, id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf presentViewController:controller animated:YES completion:nil];
    };
    
    //present通知Controller作出相应的处理
    self.photoPreviewPresenter.presenterHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - SETTER/GETTER
- (PhotoPreviewView *)photoPreviewView {
    if (!_photoPreviewView) {
        _photoPreviewView = [[PhotoPreviewView alloc] initWithFrame:CGRectZero];
    }
    return _photoPreviewView;
}

- (PhotoPreviewPresenter *)photoPreviewPresenter {
    if (!_photoPreviewPresenter) {
        _photoPreviewPresenter = [[PhotoPreviewPresenter alloc] init];
    }
    return _photoPreviewPresenter;
}

@end
