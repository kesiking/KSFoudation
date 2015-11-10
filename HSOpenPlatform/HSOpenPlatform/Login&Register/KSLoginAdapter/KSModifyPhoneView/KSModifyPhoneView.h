//
//  KSModifyPhoneView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "KSResetViewCtl.h"
#import "KSLoginService.h"

typedef void (^modifyPhoneSuccessActionBlock)(BOOL modifyPhoneSuccess);

@interface KSModifyPhoneView : KSView{
    KSResetViewCtl    *_resetViewCtl;
    KSLoginService    *_validateCodeService;
    KSLoginService    *_modifyService;
}

@property (nonatomic, strong) NSString          *user_password;

// 视觉控件集合
@property (nonatomic, strong,setter=setResetViewCtl:,getter=getResetViewCtl) KSResetViewCtl    *resetViewCtl;

@property (nonatomic, strong,setter=setModifyService:,getter=getModifyService) KSLoginService    *modifyService;

@property (nonatomic, strong,setter=setValidateCodeService:,getter=getValidateCodeService) KSLoginService        *validateCodeService;

@property (nonatomic, strong) modifyPhoneSuccessActionBlock modifyPhoneSuccessAction;

@end
