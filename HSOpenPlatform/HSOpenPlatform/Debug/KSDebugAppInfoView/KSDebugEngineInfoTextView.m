//
//  WeAppDebugEngineInfoTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-6.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugEngineInfoTextView.h"

@implementation KSDebugEngineInfoTextView

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"工具介绍"];
    [self.debugTextView setFont:[UIFont boldSystemFontOfSize:18]];
}

-(void)startDebug{
    [super startDebug];
    
    self.debugTextView.text = @"本工具由爱家团队开发\n\n工具介绍：\n1、查看使用内存及CPU，实时监控性能数据。\n2、查看3D视图结构，了解视图层次情况。\n3、查看滑动帧率，实时监控列表滑动性能。\n4、查看网络请求，统计每个页面发出的请求及流量消耗。\n5、支持网格构图，可直观反映页面布局是否按照UI设计。\n6、支持查看用户轨迹，当应用crash是会自动存储crash日志及用户操作路劲。\n7、支持查看页面布局，可查看页面上可展示区域中的每一个元素的相关信息。\n8、查看日志信息，并支持上传、清除操作。\n9、查看页面启动耗时，可实时监控每个页面的启动情况。\n\n使用简介：\n1、点击圆形按钮“点”弹出出现工具栏。\n2、滑动工具栏，并点击所需要的工具。\n3、点击关闭或是重新点击工具栏位置可取消选中工具。例如，选择了“栅格”按钮，打开栅格工具，在整个屏幕上会出现蓝色栅格，此时再次点击“栅格”按钮即可取消工具。\n\n版本：1.0\n时间：2015年12月\n开发人员：孟希羲、薛天琪、金苗";
}

-(void)endDebug{
    [super endDebug];
}

@end
