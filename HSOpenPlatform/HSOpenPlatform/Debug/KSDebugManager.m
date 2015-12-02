//
//  WeAppDebugManager.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugManager.h"
#import "KSDebugEnviroment.h"
#import "KSDebugOperationView.h"

@interface KSDebugManager()

@property(nonatomic, strong)  KSDebugEnviroment*     debugEnviromeng;

@property(nonatomic, weak)    UIWindow*                 debugWindow;

@property(nonatomic, strong)  KSDebugOperationView*  operationView;

@property(nonatomic, assign)  BOOL                   debugToolsEnabel;

@end

@implementation KSDebugManager

+ (KSDebugManager *)shareInstance {
    static KSDebugManager * shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
        [shareInstance setupShareInstance];
    });
    
    return shareInstance;
}

+(void)setupDebugManager{
    [[self shareInstance] setupDebugManager];
}

+(void)setupDebugToolsEnable:(BOOL)debugToolsEnabel{
    [[self shareInstance] setDebugToolsEnabel:debugToolsEnabel];
}

-(void)setupShareInstance{
    self.debugWindow = [[UIApplication sharedApplication] keyWindow];
}

-(void)setupDebugManager{
    if (_operationView == nil) {
        _operationView = [[KSDebugOperationView alloc] initWithFrame:CGRectMake(0, 44, self.debugWindow.frame.size.width, 44)];
        _operationView.backgroundColor = [UIColor clearColor];
        [self.debugWindow addSubview:_operationView];
    }
    
    [_operationView setDebugViewReference:self.debugWindow];
    [_operationView setDebugEnviromeng:self.debugEnviromeng];
    _debugToolsEnabel = YES;
}

-(void)setDebugToolsEnabel:(BOOL)debugToolsEnabel{
    _debugToolsEnabel = debugToolsEnabel;
    if (!debugToolsEnabel) {
        [self.operationView removeFromSuperview];
        self.operationView = nil;
        self.debugEnviromeng = nil;
    }else{
        [self setupDebugManager];
    }
}

-(KSDebugEnviroment *)debugEnviromeng{
    if (_debugEnviromeng == nil) {
        _debugEnviromeng = [[KSDebugEnviroment alloc] init];
    }
    return _debugEnviromeng;
}

@end
