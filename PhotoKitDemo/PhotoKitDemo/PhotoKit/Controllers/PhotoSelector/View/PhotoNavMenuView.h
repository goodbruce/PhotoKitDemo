//
//  PhotoNavMenu.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoNavMenuItem.h"
#import "PhotoNavMenuContentView.h"

@protocol PhotoNavMenuViewDelegate;
@interface PhotoNavMenuView : UIView

@property (nonatomic, weak) id<PhotoNavMenuViewDelegate>delegate;
@property (nonatomic, strong) NSArray *menuItems;

- (instancetype)initWithOringinFrame:(CGFloat)oringinY
                               items:(NSArray *)items
                           superView:(UIView *)superView;

- (void)show;
- (void)dismiss;

@end

@protocol PhotoNavMenuViewDelegate <NSObject>

- (void)selectedMenuItemDidClicked:(PhotoNavMenuItem *)item;

@end
