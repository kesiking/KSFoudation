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
// 控制scrollView的frame
@property (nonatomic, assign) CGRect             frame;
// 滑动速度高于阈值时设置为NO，速度较慢或是停止时设置为YES，标识图片在活动过程中是否可以加载
@property (nonatomic, assign) BOOL               canImageRefreshed;
// 预留字段，暂时没有使用
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
