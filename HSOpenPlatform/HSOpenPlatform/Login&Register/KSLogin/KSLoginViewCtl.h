//
//  KSLoginViewCtl.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeAppBasicFieldView.h"

@class KSLoginViewCtl;

typedef void (^doLoginBlock)        (KSLoginViewCtl* loginViewCtl);

typedef void (^doRegisterBlock)     (KSLoginViewCtl* loginViewCtl);

typedef void (^doResetPwdBlock)     (KSLoginViewCtl* loginViewCtl);

typedef void (^doCancelLoginBlock)  (KSLoginViewCtl* loginViewCtl);

@interface KSLoginViewCtl : UIView

@property (nonatomic, strong) UIImageView         *logo_imgView;
@property (nonatomic, strong) UIImageView         *description_logo_imgView;
@property (nonatomic, strong) WeAppBasicFieldView *text_phoneNum;
@property (nonatomic, strong) WeAppBasicFieldView *text_psw;
@property (nonatomic, strong) UIButton            *btn_login;
@property (nonatomic, strong) UIButton            *btn_register;
@property (nonatomic, strong) UIButton            *btn_cancel;
@property (nonatomic, strong) UIButton            *btn_forgetPwd;
@property (nonatomic, strong) UIView              *navgationView;

@property (nonatomic, copy) doLoginBlock       loginBlock;
@property (nonatomic, copy) doRegisterBlock    registerBlock;
@property (nonatomic, copy) doResetPwdBlock    resetPwdBlock;
@property (nonatomic, copy) doCancelLoginBlock cancelLoginBlock;

@end
