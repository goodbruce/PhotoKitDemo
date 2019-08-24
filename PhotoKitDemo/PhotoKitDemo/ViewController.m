//
//  ViewController.m
//  PhotoKitDemo
//
//  Created by bruce on 2019/8/23.
//  Copyright © 2019年 bruce. All rights reserved.
//

#import "ViewController.h"
#import "PhotoSelectorViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"相册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor brownColor].CGColor;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(200, 150, 100, 45);
    [self.view addSubview:button];
}

- (void)photoButtonAction {
    BOOL hasAuth = [[PhotoKitManager shareInstance] authorizationAlbumStatus];
    if (!hasAuth) {
        return;
    }
    
    PhotoSelectorViewController *photoSelector = [[PhotoSelectorViewController alloc] init];
    photoSelector.needMaxPhotoCount = 6;
    photoSelector.needMediaType = NeedShowMediaTypeAll;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:photoSelector];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

@end
