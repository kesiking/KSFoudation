//
//  KSScrollViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDataSource.h"

@interface KSScrollViewController : NSObject<UIScrollViewDelegate>{
    // for read
    KSDataSource*      _dataSourceRead;
    // for write
    KSDataSource*      _dataSourceWrite;
}

@property (nonatomic, strong) UIScrollView*      scrollView;

// for read
@property (nonatomic, strong) KSDataSource*      dataSourceRead;
// for write
@property (nonatomic, strong) KSDataSource*      dataSourceWrite;

@property (nonatomic, assign) CGRect             frame;

@property (nonatomic, assign) BOOL               canImageRefreshed;

@property (nonatomic, assign) BOOL               listComponentDidRelease;

// 滑动到offset位置
-(void)scrollRectToOffsetWithAnimated:(BOOL)animated;

// override subclass 在置顶屏幕内刷新image
-(void)loadImagesForOnscreenCells;

// override subclass 刷新数据
-(void)reloadData;

// 默认返回YES，需要异步线程渲染数据
-(BOOL)needQueueLoadData;

// 释放内存
-(void)releaseConstrutView;

@end
