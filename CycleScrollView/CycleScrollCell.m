//
//  CycleScrollCell.m
//  CycleScrollView
//
//  Created by Dwt on 2016/11/30.
//  Copyright © 2016年 Dwt. All rights reserved.
//

#import "CycleScrollCell.h"

@implementation CycleScrollCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.hidden = NO;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.onlyShowText) {
        _titleLabel.frame = self.bounds;
    }else{
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.frame.size.width;
        CGFloat titleLabelH = 30;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.frame.size.height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}
@end
