//
//  PhotoSelectorView.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorMediaBar.h"
#import "NavMenuButton.h"

@interface PhotoSelectorView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SelectorMediaBar *toolBar;

@end
