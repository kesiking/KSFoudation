//
//  WeAppDebugPageViewJsonTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-4.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugPageViewJsonTextView.h"

@implementation KSDebugPageViewJsonTextView

#ifdef DEBUG
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"协议数据",@"title",NSStringFromClass([self class]),@"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"协议数据"];
}

-(void)startDebug{
    [super startDebug];
}

-(void)endDebug{
    [super endDebug];
}

@end
