//
//  PhotoModel.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (void)setPhasset:(PHAsset *)phasset {
    _phasset = phasset;
    self.identifier = phasset.localIdentifier;
}

@end
