//
//  KSResetView.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSResetViewCtl.h"
#import "KSLoginService.h"

@interface KSResetView : KSView{
    KSResetViewCtl    *_resetViewCtl;
    KSLoginService    *_validateCodeService;
    KSLoginService    *_checkAccountNameService;
    KSLoginService    *_validateCodeCheckService;
}

// 视觉控件集合
@property (nonatomic, strong,setter=setResetViewCtl:,getter=getResetViewCtl) KSResetViewCtl    *resetViewCtl;

@property (nonatomic, strong,setter=setValidateCodeService:,getter=getValidateCodeService) KSLoginService        *validateCodeService;

@property (nonatomic, strong,setter=setCheckAccountNameService:,getter=getCheckAccountNameService) KSLoginService        *checkAccountNameService;

@property (nonatomic, strong,setter=setValidateCodeCheckService:,getter=getValidateCodeCheckService) KSLoginService        *validateCodeCheckService;

@property (nonatomic, strong) NSString                  *user_phone;


@end
