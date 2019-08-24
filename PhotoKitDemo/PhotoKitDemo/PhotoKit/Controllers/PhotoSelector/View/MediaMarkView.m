//
//  MediaMarkView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/4.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "MediaMarkView.h"

@interface MediaMarkView ()

@property (nonatomic, strong) UIView *backImageView;  //背景图
@property (nonatomic, strong) UILabel *titleLabel;  //标题

@end

@implementation MediaMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        self.backImageView.clipsToBounds = YES;
        [self addSubview:self.backImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setMediaTitle:(NSString *)mediaTitle {
    _mediaTitle = (mediaTitle?mediaTitle:@"");
    self.titleLabel.text = _mediaTitle;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImageView.frame = self.bounds;
    self.titleLabel.frame = self.bounds;
}

- (void)dealloc {
    
}

@end
