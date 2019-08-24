//
//  PhotoNavMenuItem.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoNavMenuItem.h"

@implementation PhotoNavMenuItem

/**
 将数据进行转换

 @param albumModel 相册model
 */
- (void)setAlbumModel:(AlbumModel *)albumModel {
    _albumModel = albumModel;
    self.title = albumModel.albumNameCh;
    self.titleColor = [UIColor blackColor];
    self.subTitle = [NSString stringWithFormat:@"%lu 张照片",(unsigned long)albumModel.result.count];
    self.subTitleColor = [UIColor blackColor];
    self.selected = YES;
}

@end
