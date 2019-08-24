//
//  NavMenuContext.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavMenuContext : NSObject

+ (float)menuWidth;
+ (float)itemCellHeight;
+ (float)animationDuration;
+ (float)backgroundAlpha;
+ (float)menuAlpha;
+ (float)bounceOffset;
+ (UIImage *)arrowImage;
+ (float)arrowPadding;
+ (UIColor *)itemsColor;
+ (UIColor *)mainColor;
+ (float)selectionSpeed;
+ (UIColor *)itemTextColor;
+ (UIColor *)selectionColor;

@end
