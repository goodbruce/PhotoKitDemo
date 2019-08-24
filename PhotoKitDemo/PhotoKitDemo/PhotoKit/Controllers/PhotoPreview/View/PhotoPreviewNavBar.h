//
//  PhotoPreviewNavBar.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPreviewNavBarDelegate;
@interface PhotoPreviewNavBar : UIView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, weak) id<PhotoPreviewNavBarDelegate> delegate;

@property (nonatomic, assign) BOOL needsAnimated;

- (void)setCurrentSelected:(BOOL)isSelected animated:(BOOL)animated;

@end

@protocol PhotoPreviewNavBarDelegate <NSObject>

- (void)back;
- (void)handleSelectDidClicked;

@end
