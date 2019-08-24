//
//  PhotoNavMenuItemCell.h
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoNavMenuItem.h"

@interface PhotoNavMenuItemCell : UITableViewCell

@property (nonatomic, strong) PhotoNavMenuItem *menuItem;

- (void)bindMenuItem:(PhotoNavMenuItem *)item;

@end
