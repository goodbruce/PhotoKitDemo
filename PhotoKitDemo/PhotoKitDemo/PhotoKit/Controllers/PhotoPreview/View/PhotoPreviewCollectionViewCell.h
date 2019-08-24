//
//  PhotoPreviewCollectionViewCell.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoKitViewUtils.h"
#import "PhotoModel.h"
#import "PhotoKitManager.h"

@protocol PhotoPreviewCollectionViewCellDelegate;
@interface PhotoPreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<PhotoPreviewCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) PhotoModel *photoModel;

@end

@protocol PhotoPreviewCollectionViewCellDelegate <NSObject>

- (void)displayCollectionCellPhotoViewTapped:(PhotoPreviewCollectionViewCell *)cell;

@end
