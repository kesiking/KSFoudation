//
//  KSRegisterValidateCodeCheckView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/13.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "WeAppBasicFieldView.h"
#import "KSValidateCodeViewCtl.h"
#import "KSLoginService.h"

typedef void (^registerActionBlock)(BOOL registerSuccess);

typedef void (^cancelActionBlock)(void);

@interface KSRegisterValidateCodeCheckView : KSView{
    KSLoginService       *_registerService;
    KSLoginService       *_validateCodeCheckService;
    KSLoginService       *_validateCodeService;
}

@property (nonatomic, strong,setter=setRegisterService:,getter=getRegisterService) KSLoginService        *registerService;

@property (nonatomic, strong,setter=setValidateCodeCheckService:,getter=getValidateCodeCheckService) KSLoginService        *validateCodeCheckService;

@property (nonatomic, strong,setter=setValidateCodeService:,getter=getValidateCodeService) KSLoginService        *validateCodeService;


@property (nonatomic, strong) KSValidateCodeViewCtl     *validateCodeView;

@property (nonatomic, strong) UIButton                  *btn_next;

@property (nonatomic, strong) NSString                  *user_phone;

@property (nonatomic, strong) NSString                  *user_password;

// 回调函数
@property (nonatomic, copy) registerActionBlock   registerActionBlock;

@property (nonatomic, copy) cancelActionBlock     cancelActionBlock;

@end
