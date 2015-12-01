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
    [self.debugTextView setEditable:NO];
    [self.debugTextView setFont:[UIFont boldSystemFontOfSize:18]];
}

-(void)startDebug{
    [super startDebug];
    
    self.debugTextView.text = @"本工具由爱家团队开发\n\n工具介绍：\n1、查看使用内存及CPU\n2、查看视图结构\n3、查看滑动帧率\n4、查看网络请求\n5、查看日志并上传日志\n6、支持网格构图\n\n版本：1.0\n时间：2015年12月\n开发人员：孟希羲、薛天琪、金苗";
}

-(void)endDebug{
    [super endDebug];
}

@end
