//
//  PhotoNavContentView.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoNavMenuItemCell.h"

@protocol PhotoNavMenuContentViewDelegate;

@interface PhotoNavMenuContentView : UIView

@property (nonatomic, weak) id<PhotoNavMenuContentViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *menuItems;

- (id)initWithFrame:(CGRect)frame;

#pragma mark - 内容控件的大小
+ (CGSize)contentSize:(NSInteger)count maxHeight:(CGFloat)maxHeight;

@end

@protocol PhotoNavMenuContentViewDelegate <NSObject>

- (void)navMenuItemDidClicked:(PhotoNavMenuItem *)item;

@end
