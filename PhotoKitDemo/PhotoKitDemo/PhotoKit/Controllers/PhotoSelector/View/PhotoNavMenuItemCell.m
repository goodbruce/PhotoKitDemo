//
//  PhotoNavMenuItemCell.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoNavMenuItemCell.h"
#import "PhotoKitManager.h"

static CGFloat kPadding = 10.0;
static CGFloat kSmallPadding = 5.0;
static CGFloat kArrowSize = 15.0;
static CGFloat kCheckedSize = 15.0;

static CGFloat kLabelHeight = 35.0;

@interface PhotoNavMenuItemCell ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *checkedImageView;

@end

@implementation PhotoNavMenuItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backImageView];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor redColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.clipsToBounds = YES;
        [self.backImageView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.backImageView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.backImageView addSubview:_subTitleLabel];
        
        _checkedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _checkedImageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        _checkedImageView.hidden = YES;
        _checkedImageView.image = [UIImage imageNamed:@"ic_image_check"];
        [self.backImageView addSubview:_checkedImageView];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.image = [UIImage imageNamed:@"ic_item_arrow"];
        [self.backImageView addSubview:_arrowImageView];
        
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineImageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [self.backImageView addSubview:_lineImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImageView.frame = self.bounds;
    
    CGFloat iconOriginX = kPadding;
    
    CGFloat titlePadding = kPadding;
    
    CGFloat iconImageSize = (CGRectGetHeight(self.backImageView.frame) - 2*kSmallPadding);
    
    self.arrowImageView.frame = CGRectMake(CGRectGetWidth(self.backImageView.frame) - kArrowSize - kPadding, (CGRectGetHeight(self.backImageView.frame) - kArrowSize)/2, kArrowSize, kArrowSize);
    
    self.checkedImageView.frame = CGRectMake(CGRectGetMinX(self.arrowImageView.frame) - kCheckedSize - kPadding, (CGRectGetHeight(self.backImageView.frame) - kCheckedSize)/2, kCheckedSize, kCheckedSize);

    self.iconImageView.frame = CGRectMake(iconOriginX, kSmallPadding, iconImageSize, iconImageSize);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+titlePadding, (CGRectGetHeight(self.backImageView.frame) - kLabelHeight*2)/2, CGRectGetMinX(self.checkedImageView.frame) - (CGRectGetMaxX(self.iconImageView.frame) + titlePadding) - 2*titlePadding, kLabelHeight);
    
    self.subTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+titlePadding, CGRectGetMaxY(self.titleLabel.frame), CGRectGetMinX(self.checkedImageView.frame) - (CGRectGetMaxX(self.iconImageView.frame) + titlePadding) - 2*titlePadding, kLabelHeight);

    self.lineImageView.frame = CGRectMake(0, CGRectGetHeight(self.backImageView.frame)-1.0, CGRectGetWidth(self.backImageView.frame), 1.0);
}

- (void)bindMenuItem:(PhotoNavMenuItem *)item {
    self.menuItem = item;
    
    self.titleLabel.text = (item.title?item.title:@"");
    self.titleLabel.textColor = item.titleColor;
    
    self.subTitleLabel.text = (item.subTitle?item.subTitle:@"");
    self.subTitleLabel.textColor = item.subTitleColor;

    self.checkedImageView.hidden = !item.selected;
    
    CGSize size = CGSizeMake(160, 160);
    __weak typeof(self) weakSelf = self;
    [[PhotoKitManager shareInstance] reqAblumImageForAsset:item.albumModel.asset targetSize:size resultHandler:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.menuItem.image = result;
        strongSelf.iconImageView.image = result;
    }];
    
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.backImageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];;
    } else {
        self.backImageView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc {
    
}

@end
