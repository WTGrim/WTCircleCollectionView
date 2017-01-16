//
//  WTCycleScrollView.m
//  CycleScrollView
//
//  Created by Dwt on 2016/11/29.
//  Copyright © 2016年 Dwt. All rights reserved.
//

#import "WTCycleScrollView.h"
#import "CycleScrollCell.h"
#import <UIImageView+WebCache.h>

static NSString *const cellID = @"cellID";
@interface WTCycleScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, weak)UIImageView *bgImageView;
@property(nonatomic, strong)NSArray *imagePathsArray;
@property(nonatomic, weak)NSTimer *timer;
@property(nonatomic, weak)UIPageControl *pageControl;
@property(nonatomic, assign)NSInteger totalItemCount;
@property(nonatomic, weak)UICollectionViewFlowLayout *flowLayout;

@end
@implementation WTCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self setupItemView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
    [self setupItemView];
}

- (void)initView{
    self.pageControlAliment = PageControlAlimentCenter;
    _timeInterVal = 2.0;
    _autoScroll = YES;
    _showPageControl = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupItemView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[CycleScrollCell class] forCellWithReuseIdentifier:cellID];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollsToTop = NO;
    _collectionView = collectionView;
    [self addSubview:collectionView];
}

+ (instancetype)netCycleScrollViewWithFrame:(CGRect)frame delegate:(id<CycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage{
    WTCycleScrollView *cycleScrollView = [[self alloc]initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    return cycleScrollView;
}

+ (instancetype)localCycleScrollViewWithFrame:(CGRect)frame loop:(BOOL)loop imageNames:(NSArray *)imageNames{
    WTCycleScrollView *cycleScrollView = [[self alloc]initWithFrame:frame];
    cycleScrollView.loop = loop;
    cycleScrollView.imageNamesArray = imageNames;
    return cycleScrollView;
}

#pragma mark - setter
- (void)setPlaceholderImage:(UIImage *)placeholderImage{
    _placeholderImage = placeholderImage;
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:_bgImageView belowSubview:self.collectionView];
    }
    _bgImageView.image = placeholderImage;
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setLoop:(BOOL)loop{
    _loop = loop;
    if(self.imagePathsArray.count){
        self.imagePathsArray = self.imagePathsArray;
    }
}


- (void)setImagePathsArray:(NSArray *)imagePathsArray{
    [self invalidateTimer];
    _imagePathsArray = imagePathsArray;
    _totalItemCount = _loop ? self.imagePathsArray.count * 100: self.imagePathsArray.count;
    
    if(imagePathsArray.count != 1){
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }else{
        self.collectionView.scrollEnabled = NO;
    }
    [self initPageControl];
    [self.collectionView reloadData];
}

- (void)setImageUrlsArray:(NSArray *)imageUrlsArray{
    _imageUrlsArray = imageUrlsArray;
    NSMutableArray *tempArr = [NSMutableArray new];
    [imageUrlsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlStr;
        if ([obj isKindOfClass:[NSString class]]) {
            urlStr = obj;
        }else if ([obj isKindOfClass:[NSURL class]]){
            NSURL *url = (NSURL *)obj;
            urlStr = [url absoluteString];
        }
        if (urlStr) {
            [tempArr addObject:urlStr];
        }
    }];
    self.imagePathsArray = [tempArr copy];
}


- (void)setTitlesArray:(NSArray *)titlesArray{
    _titlesArray = titlesArray;
    if (self.onlyShowText) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i = 0; i < _titlesArray.count; i++) {
            [tempArray addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageUrlsArray = [tempArray copy];
    }
}


- (void)initPageControl{
    if (_pageControl)[_pageControl removeFromSuperview];
    if (self.onlyShowText || self.imageUrlsArray.count == 0) return;
    
    int pageControlIndex = [self pageControlIndexWithIndex:[self getCurrentIndex]];
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = self.imagePathsArray.count;
    pageControl.currentPage = pageControlIndex;
    pageControl.userInteractionEnabled = NO;
    _pageControl = pageControl;
    [self addSubview:pageControl];
}

- (int)getCurrentIndex{
    if (self.collectionView.frame.size.width == 0||self.collectionView.frame.size.height == 0) return 0;
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (int)(self.collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }else{
        index = (int)(self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (int)pageControlIndexWithIndex:(NSInteger)index{
    return (int)index % self.imagePathsArray.count;
}

- (void)autoToScroll{
    if(_totalItemCount == 0)return;
    int currentIndex = [self getCurrentIndex];
    int scrollToIndex = currentIndex + 1;
    [self scrollToIndex:scrollToIndex];
}

- (void)scrollToIndex:(int)index{
    if (index >= _totalItemCount) {
        if (_loop) {
            index = _totalItemCount *0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)initTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterVal target:self selector:@selector(autoToScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self initTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _collectionView.frame = self.bounds;
    if (self.collectionView.contentOffset.x == 0 && _totalItemCount) {
        int index = 0;
        if (_loop) {
            index = _totalItemCount * 0.5;
        }else{
            index = 0;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    self.pageControl.frame = CGRectZero;
    self.pageControl.userInteractionEnabled = NO;
    CGFloat width = 100;
    if (_pageControlAliment == PageControlAlimentCenter) {
        self.pageControl.frame = CGRectMake((self.frame.size.width - width) * 0.5, self.frame.size.height - 15, width, 8);
        
    }
    if (_pageControlAliment == PageControlAlimentRight) {
        self.pageControl.frame = CGRectMake(self.frame.size.width - width - 20, self.frame.size.height - 15, width, 8);
    }
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.hidden = !_showPageControl;
    if (_bgImageView) {
        _bgImageView.frame = self.bounds;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)dealloc{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - datasource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    long index = [self pageControlIndexWithIndex:indexPath.item];
    NSString *path = self.imagePathsArray[index];
    if (!self.onlyShowText && [path isKindOfClass:[NSString class]]) {
        if ([path hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:self.placeholderImage];
        }else{
            UIImage *image = [UIImage imageNamed:path];
            if (!image) {
               image = [UIImage imageWithContentsOfFile:path];
            }
            cell.imageView.image = image;
        }
    }else if (!self.onlyShowText && [path isKindOfClass:[UIImage class]]){
        cell.imageView.image = (UIImage *)path;
    }
    if (self.titlesArray.count && index < _titlesArray.count) {
        cell.titleLabel.text = [NSString stringWithFormat:@"    %@", _titlesArray[index]];
    }
    cell.onlyShowText = self.onlyShowText;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithIndex:indexPath.item]];
    }
    if (_didSelectItemAtIndexBlock) {
        _didSelectItemAtIndexBlock([self pageControlIndexWithIndex:indexPath.item]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.imagePathsArray.count) return;
    int index = [self getCurrentIndex];
    int pageControlIndex = [self pageControlIndexWithIndex:index];
    _pageControl.currentPage = pageControlIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoScroll) {
        [self initTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (!self.imagePathsArray.count)return;
//    int index = [self getCurrentIndex];
//    int pageControlIndex = [self pageControlIndexWithIndex:index];
//    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
//        [_delegate cycleScrollView:self didSelectItemAtIndex:pageControlIndex];
//    }
//    if (_didSelectItemAtIndexBlock) {
//        _didSelectItemAtIndexBlock(pageControlIndex);
//    }
}




@end
