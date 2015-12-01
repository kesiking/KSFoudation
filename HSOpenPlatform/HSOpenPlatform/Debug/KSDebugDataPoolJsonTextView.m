//
//  WeAppDebugDataPoolJsonTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-4.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugDataPoolJsonTextView.h"

@implementation KSDebugDataPoolJsonTextView

#ifdef DEBUG
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"数据池快照",@"title",NSStringFromClass([self class]),@"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"数据池快照"];
}

-(void)startDebug{
    [super startDebug];
}

-(void)endDebug{
    [super endDebug];
}

-(void)modifyButtonClick:(id)sender{
    NSString *text = self.debugTextView.text;
    NSDictionary *dataDict = [self generateDictionaryWithString:text];
    if (dataDict == nil) {
        return;
    }
    
    [self endDebug];
}


@end
