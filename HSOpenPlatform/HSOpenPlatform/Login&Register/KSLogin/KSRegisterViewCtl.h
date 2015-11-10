//
//  KSRegisterViewCtl.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeAppBasicFieldView.h"
#import "KSValidateCodeViewCtl.h"

@class KSRegisterViewCtl;

typedef void (^doRegisterBlock)         (KSRegisterViewCtl* registerViewCtl);
typedef void (^doNextBlock)             (KSRegisterViewCtl* registerViewCtl);
typedef void (^doCancelRegisterBlock)   (KSRegisterViewCtl* registerViewCtl);

@interface KSRegisterViewCtl : KSValidateCodeViewCtl

@property (nonatomic, strong) UIImageView               *logo_imgView;
@property (nonatomic, strong) WeAppBasicFieldView       *text_phoneNum;
@property (nonatomic, strong) WeAppBasicFieldView       *text_psw;
@property (nonatomic, strong) WeAppBasicFieldView       *text_inviteCode;
@property (nonatomic, strong) WeAppBasicFieldView       *text_userName;

@property (nonatomic, strong) UIButton                  *btn_register;
@property (nonatomic, strong) UIButton                  *btn_next;
@property (nonatomic, strong) UIButton                  *btn_cancel;

@property (nonatomic, copy) doRegisterBlock           registerBlock;
@property (nonatomic, copy) doNextBlock               nextBlock;
@property (nonatomic, copy) doCancelRegisterBlock     cancelRegisterBlock;

@end
