//
//  WeAppDebugRequestDataTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-4.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugRequestDataTextView.h"
#import "KSDebugUtils.h"
#import "KSDebugManager.h"

@implementation KSDebugRequestDataTextView

#ifdef KSDebugToolsEnable
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"网络请求",@"title",NSStringFromClass([self class]),@"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"网络请求"];
}

-(void)startDebug{
    [super startDebug];
    UIViewController* currentAppearedVC = [KSDebugUtils getCurrentAppearedViewController];
    self.debugTextView.text = [NSString stringWithFormat:@"当前展示viewController:%@,%@",NSStringFromClass([currentAppearedVC class]),currentAppearedVC];
}

-(void)endDebug{
    [super endDebug];
}

@end
