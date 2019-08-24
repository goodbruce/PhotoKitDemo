//
//  TakePhotoCollectionViewCell.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakePhotoCollectionViewCellDelegate;
@interface TakePhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<TakePhotoCollectionViewCellDelegate> delegate;

@end

@protocol TakePhotoCollectionViewCellDelegate <NSObject>

- (void)takePhotoCellButtonDidClicked:(TakePhotoCollectionViewCell *)cell;

@end

