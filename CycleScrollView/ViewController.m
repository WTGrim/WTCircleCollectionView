//
//  ViewController.m
//  CycleScrollView
//
//  Created by Dwt on 2016/11/28.
//  Copyright © 2016年 Dwt. All rights reserved.
//

#import "ViewController.h"
#import "WTCycleScrollView.h"
@interface ViewController ()<CycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    self.navigationItem.title = @"轮播封装";
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imagesURLStrings = @[
                                  @"http://movie.videoland.com.tw/image/photoa/20140701.jpg",
                                  @"http://www.qiyipic.com/yule/fix/20130815jzjz/da/13.jpg",
                                  @"http://imgsrc.baidu.com/forum/w%3D580/sign=63d317cb80025aafd3327ec3cbecab8d/a18b87d6277f9e2fb5c84c031d30e924b899f338.jpg",
                                  @"http://pic33.nipic.com/20130909/2828440_222652434000_2.jpg"
                                  ];
    
    NSArray *titles = @[@"电影激战",
                        @"彭于晏",
                        @"海报",
                        @"电影剧照"
                        ];
    NSArray *titleOnly = @[@"代码神兽出来跑了一圈", @"代码", @"音乐", @"咖啡"];
    
    WTCycleScrollView *cycleScrollView = [WTCycleScrollView netCycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"123.jpg"]];
    cycleScrollView.autoScroll =  YES;
    cycleScrollView.loop = YES;
    cycleScrollView.pageControlAliment = PageControlAlimentRight;
    cycleScrollView.showPageControl = YES;
    cycleScrollView.timeInterVal = 3.5;
    cycleScrollView.cellWidth = [UIScreen mainScreen].bounds.size.width - 40;
    cycleScrollView.margin = 5;
    cycleScrollView.titlesArray = titles;
    cycleScrollView.imageUrlsArray = imagesURLStrings;
    [self.view addSubview:cycleScrollView];
    
    //文字广告
    WTCycleScrollView *cycleScrollView2 = [WTCycleScrollView netCycleScrollViewWithFrame:CGRectMake(0, 230, self.view.bounds.size.width, 30) delegate:self placeholderImage:nil];
    cycleScrollView2.onlyShowText = YES;
    cycleScrollView2.autoScroll = YES;
    cycleScrollView2.loop = YES;
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView2.timeInterVal = 2.5;
    cycleScrollView2.titlesArray = titleOnly;
    [self.view addSubview:cycleScrollView2];
}

- (void)cycleScrollView:(WTCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了%ld", (long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
