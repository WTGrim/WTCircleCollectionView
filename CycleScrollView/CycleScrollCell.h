//
//  CycleScrollCell.h
//  CycleScrollView
//
//  Created by Dwt on 2016/11/30.
//  Copyright © 2016年 Dwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollCell : UICollectionViewCell

@property(nonatomic, weak)UIImageView *imageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, assign)BOOL onlyShowText;
@end
