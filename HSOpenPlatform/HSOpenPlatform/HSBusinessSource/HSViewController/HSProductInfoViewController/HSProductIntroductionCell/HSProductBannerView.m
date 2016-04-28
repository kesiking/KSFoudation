//
//  HSProductBannerView.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductBannerView.h"
#import "SDCycleScrollView.h"

@interface HSProductBannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView *bannerView;

@end

@implementation HSProductBannerView

- (void)setupView {
    [self addSubview:self.bannerView];
}

- (void)setProductUrlImages:(NSArray *)productUrlImages {
    _productUrlImages = productUrlImages;

    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    if (productUrlImages.count > 0) {
        for (NSDictionary *dic in productUrlImages) {
            NSString *imageString = [dic objectForKey:@"productImage"];
            if (imageString) {
                [muArr addObject:imageString];
            }
        }
    }
    self.bannerView.imageURLStringsGroup = (NSArray *)muArr;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerView.currentPageDotColor = RGB(12, 96, 254);
        _bannerView.pageDotColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.autoScrollTimeInterval = 3;
        _bannerView.backgroundColor = [UIColor clearColor];
    }
    return _bannerView;
}

@end
