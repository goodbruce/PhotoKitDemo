//
//  PhotoNavContentView.m
//  PhotoKitPro
//
//  Created by bruce on 2018/6/5.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "PhotoNavMenuContentView.h"

static CGFloat kItemHeight = 80.0;

@interface PhotoNavMenuContentView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PhotoNavMenuContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)setMenuItems:(NSMutableArray *)menuItems {
    _menuItems = menuItems;
    [self.tableView reloadData];
    [self setNeedsLayout];
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoNavMenuItemCell";
    PhotoNavMenuItemCell *cell = (PhotoNavMenuItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoNavMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PhotoNavMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
    [cell bindMenuItem:item];
    
    return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PhotoNavMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];

    if (item.action) {
        item.action();
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navMenuItemDidClicked:)]) {
        [self.delegate navMenuItemDidClicked:item];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kItemHeight;
}

#pragma mark - SETTER/GETTER
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    return _tableView;
}

#pragma mark - 内容控件的大小
+ (CGSize)contentSize:(NSInteger)count maxHeight:(CGFloat)maxHeight {
    
    CGFloat aHeigth = 0.0;
    
    aHeigth = count*kItemHeight;
    
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), MIN(aHeigth, maxHeight));
}

- (void)dealloc {
    
}

@end
