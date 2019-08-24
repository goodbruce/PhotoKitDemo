//
//  NavMenuButton.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavMenuButton : UIControl

@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, strong) NSString *title;

@end
