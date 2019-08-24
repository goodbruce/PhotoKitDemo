//
//  PhotoPreviewViewController.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoKitManager.h"

@interface PhotoPreviewViewController : UIViewController

/**
 当前选中的图片
 */
@property (nonatomic, strong) NSString *currentPhotoIdentifier;

/**
 是否预览选中的图片
 */
@property (nonatomic, assign) BOOL isShowSelected;

@end
