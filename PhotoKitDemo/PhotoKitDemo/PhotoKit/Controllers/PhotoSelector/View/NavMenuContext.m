//
//  NavMenuContext.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "NavMenuContext.h"

@implementation NavMenuContext

+ (float)menuWidth
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.frame.size.width;
}

+ (float)itemCellHeight
{
    return 44.0f;
}

+ (float)animationDuration
{
    return 0.3f;
}

+ (float)backgroundAlpha
{
    return 0.6;
}

+ (float)menuAlpha
{
    return 0.8;
}

+ (float)bounceOffset
{
    return -7.0;
}

+ (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"ic_arrow_down"];
}

+ (float)arrowPadding
{
    return 13.0;
}

+ (UIColor *)itemsColor
{
    return [UIColor blackColor];
}

+ (UIColor *)mainColor
{
    return [UIColor blackColor];
}

+ (float)selectionSpeed
{
    return 0.15;
}

+ (UIColor *)itemTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)selectionColor
{
    return [UIColor colorWithRed:45.0/255.0 green:105.0/255.0 blue:166.0/255.0 alpha:1.0];
}

@end
