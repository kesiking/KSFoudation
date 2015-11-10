//
//  KSModifyPasswordView.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSResetViewCtl.h"
#import "KSLoginService.h"

typedef void (^modifyPasswordActionBlock)(BOOL resetSuccess);

@interface KSModifyPasswordView : KSView{
    KSResetViewCtl    *_resetViewCtl;
    KSLoginService    *_service;
}

@property (nonatomic, strong) NSString          *user_phone;

// 视觉控件集合
@property (nonatomic, strong,setter=setResetViewCtl:,getter=getResetViewCtl) KSResetViewCtl    *resetViewCtl;

@property (nonatomic, strong,setter=setService:,getter=getService) KSLoginService    *service;


@property (nonatomic, copy) modifyPasswordActionBlock modifyPasswordAction;

@end
