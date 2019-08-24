//
//  VideoPreviewViewController.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "VideoPreviewViewController.h"
#import "VideoPreviewPresenter.h"

@interface VideoPreviewViewController ()

@property (nonatomic, strong) VideoPreviewView *videoPreviewView;
@property (nonatomic, strong) VideoPreviewPresenter *videoPreviewPresenter;

@end

@implementation VideoPreviewViewController

- (void)loadView {
    [super loadView];
    self.view = self.videoPreviewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self configuration];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.videoPreviewPresenter startPlayerVideo];
}

- (void)configuration {
    self.videoPreviewPresenter.currentVideoIdentifier = self.currentVideoIdentifier;
    self.videoPreviewPresenter.videoPreviewView = self.videoPreviewView;
    self.videoPreviewView.delegate = self.videoPreviewPresenter;
    
    __weak typeof(self) weakSelf = self;
    self.videoPreviewPresenter.popControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.videoPreviewPresenter.dismissControllerHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.videoPreviewPresenter.presentController = ^(UIViewController *controller, id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf presentViewController:controller animated:YES completion:nil];
    };
    
    //present通知Controller作出相应的处理
    self.videoPreviewPresenter.presenterHandler = ^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
    };    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - SETTER/GETTER
- (VideoPreviewView *)videoPreviewView {
    if (!_videoPreviewView) {
        _videoPreviewView = [[VideoPreviewView alloc] initWithFrame:CGRectZero];
    }
    return _videoPreviewView;
}

- (VideoPreviewPresenter *)videoPreviewPresenter {
    if (!_videoPreviewPresenter) {
        _videoPreviewPresenter = [[VideoPreviewPresenter alloc] init];
    }
    return _videoPreviewPresenter;
}

@end
