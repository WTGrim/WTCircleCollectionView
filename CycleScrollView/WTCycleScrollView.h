//
//  WTCycleScrollView.h
//  CycleScrollView
//
//  Created by Dwt on 2016/11/29.
//  Copyright © 2016年 Dwt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageControlAlimentCenter,
    PageControlAlimentRight,
} PageControlAliment;

@class WTCycleScrollView;
@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollView:(WTCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
@end
@interface WTCycleScrollView : UIView
//网络
+ (instancetype)netCycleScrollViewWithFrame:(CGRect)frame delegate:(id<CycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;
//本地
+ (instancetype)localCycleScrollViewWithFrame:(CGRect)frame loop:(BOOL)loop imageNames:(NSArray *)imageNames;
@property(nonatomic, weak)id<CycleScrollViewDelegate> delegate;
@property(nonatomic, copy)void(^didSelectItemAtIndexBlock)(NSInteger index);
@property(nonatomic, strong)NSArray *imageUrlsArray;
@property(nonatomic, strong)NSArray *titlesArray;

//本地图片
@property(nonatomic, strong)NSArray *imageNamesArray;
@property(nonatomic, strong)UIImage *placeholderImage;
//自动滚动时间间隔
@property(nonatomic, assign)CGFloat timeInterVal;
@property(nonatomic, assign)BOOL autoScroll;
//是否无限滚动
@property(nonatomic, assign)BOOL loop;
//滚动方向
@property(nonatomic, assign)UICollectionViewScrollDirection scrollDirection;
@property(nonatomic, assign)PageControlAliment pageControlAliment;
@property(nonatomic, assign)BOOL showPageControl;
//文字广告
@property(nonatomic, assign)BOOL onlyShowText;

//如果需要做类似腾讯视频间距轮播(设置下面两个属性即可)
@property(nonatomic, assign)CGFloat margin;
@property(nonatomic, assign)CGFloat cellWidth;

@end
