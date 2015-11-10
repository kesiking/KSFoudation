//
//  KSValidateCodeViewCtl.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppBasicFieldView.h"

#define kValidateCodeSpaceX (15.0)

#define validate_width      (self.frame.size.width - kValidateCodeSpaceX * 2)
#define view_width          (self.frame.size.width)

#define text_smsCode_width  (160.0)
#define btn_smsCode_width   (120.0)

#define text_height         (40.0)
#define text_border         (10.0)

@class KSValidateCodeViewCtl;

typedef BOOL (^doGetValidateColdBlock)  (KSValidateCodeViewCtl* validateCodeViewCtl);

@interface KSValidateCodeViewCtl : UIView{
    UILabel                   *_smsCodeLabel;
    UIView                    *_smsCodeView;
    WeAppBasicFieldView       *_text_smsCode;
    UIButton                  *_btn_smsCode;
}

@property (nonatomic, strong) UILabel                   *smsCodeLabel;
@property (nonatomic, strong) WeAppBasicFieldView       *text_smsCode;
@property (nonatomic, strong) UIView                    *smsCodeView;
@property (nonatomic, strong) UIButton                  *btn_smsCode;

@property (nonatomic, assign) NSUInteger                smsCodeSeconds;

@property (nonatomic, copy) doGetValidateColdBlock      getValidateColdBlock;

-(void)resetSmsCodeButton;

-(void)showLoadingSmsCodeButton;

@end
