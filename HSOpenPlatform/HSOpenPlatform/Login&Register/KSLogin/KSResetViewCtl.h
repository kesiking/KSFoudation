//
//  KSResetViewCtl.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSValidateCodeViewCtl.h"

@class KSResetViewCtl;

typedef void (^doNextStepBlock)         (KSResetViewCtl* resetViewCtl);

typedef void (^doResetPwdDoneBlock)     (KSResetViewCtl* resetViewCtl);

@interface KSResetViewCtl : KSValidateCodeViewCtl

@property (nonatomic, strong) WeAppBasicFieldView       *text_oldPwd;
@property (nonatomic, strong) WeAppBasicFieldView       *text_newPwd;
@property (nonatomic, strong) WeAppBasicFieldView       *text_renewPwd;
@property (nonatomic, strong) UIButton                  *btn_done;

@property (nonatomic, strong) WeAppBasicFieldView       *text_phoneNum;
@property (nonatomic, strong) UIButton                  *btn_nextStep;
@property (nonatomic, strong) UIButton                  *btn_finish;

@property (nonatomic, copy) doNextStepBlock           nextStepBlock;
@property (nonatomic, copy) doResetPwdDoneBlock       resetPwdDoneBlock;

@end
