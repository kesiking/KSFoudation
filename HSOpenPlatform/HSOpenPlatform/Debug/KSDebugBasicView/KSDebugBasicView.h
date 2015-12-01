//
//  WeAppDebugBasicView.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugEnviroment.h"

#define KSDebugBasicViewDidClosedNotification @"KSDebugBasicViewDidClosedNotification"   

@protocol KSDebugProtocol <NSObject>

@property(nonatomic, weak)    KSDebugEnviroment*   debugEnviromeng;

@property(nonatomic, weak)    UIView*                 debugViewReference;

-(void)startDebug;

-(void)endDebug;

@end

@interface KSDebugBasicView : UIView<KSDebugProtocol>

@property(nonatomic, assign)    BOOL            needCancelBackgroundAction;

@property(nonatomic, assign)    BOOL            isDebuging;

@property(nonatomic, strong)    UIButton*       closeButton;

-(void)setupView;

-(void)closeButtonDidSelect;

@end
