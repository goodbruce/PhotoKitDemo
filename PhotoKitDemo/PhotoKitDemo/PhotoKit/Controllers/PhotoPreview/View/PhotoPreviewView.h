//
//  PhotoPreviewView.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPreviewNavBar.h"
#import "SelectorMediaBar.h"
#import "PhotoKitDefine.h"
#import "PhotoKitViewUtils.h"

@interface PhotoPreviewView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SelectorMediaBar *selectorBar;
@property (nonatomic, strong) PhotoPreviewNavBar *selectorNavBar;
@property (nonatomic, assign, getter = isBarHidden) BOOL barHidden;
@property (nonatomic, weak) id delegate;

@end
