//
//  HSServiceTabViewContiollerViewController.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/9/29.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSTabBasicViewController.h"

@interface HSServiceTabViewContioller : KSTabBasicViewController

@property (nonatomic, strong) NSString       *emptyDataTitle;       //空数据的提示文案

@property (nonatomic, strong) NSString       *noMoreDataTitle;      //全部数据加载完毕的提示文案

- (void)refreshData;                                                //下拉刷新操作
- (void)reloadFail;                                                 // 刷新或加载失败
//- (void)beginRefreshing;                                            //自动开始刷新



@end
