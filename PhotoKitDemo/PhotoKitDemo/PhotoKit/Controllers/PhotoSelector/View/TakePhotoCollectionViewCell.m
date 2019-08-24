//
//  TakePhotoCollectionViewCell.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "TakePhotoCollectionViewCell.h"
#import <Photos/Photos.h>

@interface TakePhotoCollectionViewCell ()

@property (nonatomic, strong) UIButton *takePhotoButton;

@end

@implementation TakePhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _takePhotoButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _takePhotoButton.backgroundColor = [UIColor whiteColor];
        [_takePhotoButton setImage:[UIImage imageNamed:@"ic_take_photo"] forState:UIControlStateNormal];
        [_takePhotoButton addTarget:self action:@selector(takePhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_takePhotoButton];
        
        /*
        NSError *err;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&err];
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        //self.session = session;
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        previewLayer.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.contentView.layer addSublayer:previewLayer];
        [session startRunning];
         */
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.takePhotoButton.frame = self.bounds;
}

- (void)takePhotoButtonClicked {
    if ([self.delegate respondsToSelector:@selector(takePhotoCellButtonDidClicked:)]) {
        [self.delegate takePhotoCellButtonDidClicked:self];
    }
}

@end
