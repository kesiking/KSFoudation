//
//  KSDoneResetView.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSResetViewCtl.h"
#import "KSLoginService.h"

typedef void (^resetPasswordActionBlock)(BOOL resetSuccess);

@interface KSDoneResetView : KSView{
    KSResetViewCtl    *_resetViewCtl;
    KSLoginService    *_service;
}

@property (nonatomic, strong) NSString          *smsCode;

@property (nonatomic, strong) NSString          *phoneNum;

// 视觉控件集合
@property (nonatomic, strong,setter=setResetViewCtl:,getter=getResetViewCtl) KSResetViewCtl    *resetViewCtl;

@property (nonatomic, strong,setter=setService:,getter=getService) KSLoginService    *service;


@property (nonatomic, strong) resetPasswordActionBlock resetPasswordAction;

@end
