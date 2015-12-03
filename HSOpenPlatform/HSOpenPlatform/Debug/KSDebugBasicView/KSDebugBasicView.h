//
//  WeAppDebugBasicView.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugEnviroment.h"
#import "KSDebugMaroc.h"

@protocol KSDebugProtocol <NSObject>

@property(nonatomic, weak)    KSDebugEnviroment*   debugEnviromeng;

@property(nonatomic, weak)    UIView*                 debugViewReference;

-(void)startDebug;

-(void)endDebug;

@end

@interface KSDebugBasicView : UIScrollView<KSDebugProtocol>

@property(nonatomic, assign)    BOOL            needCancelBackgroundAction;

@property(nonatomic, assign)    BOOL            isDebuging;

@property(nonatomic, strong)    UIButton*       closeButton;

-(void)setupView;

-(void)closeButtonClick:(id)sender;

-(void)closeButtonDidSelect;

-(void)canceBackgroundlAction;

/*!
 *  @author 孟希羲, 15-12-03 09:12:57
 *
 *  @brief  当关闭按钮被点击时是否需要发出关闭的KSDebugBasicViewDidClosedNotification的通知，默认返回YES，发出通知后会将选择栏中的选中状态取消
 *
 *  @return YES or NO，default is YES
 *
 *  @since  1.0
 */
-(BOOL)shouldNotificationDidClosedMessage;

@end
