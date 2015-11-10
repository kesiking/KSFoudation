//
//  WeAppBasicFieldView.h
//  WeAppSDK
//
//  Created by 逸行 on 14-12-25.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSInsetsTextField.h"
#import "KSLineBorderTextField.h"

typedef void (^textValueDidChangedBlock)        (UITextField* textView);

@interface WeAppBasicFieldView : UIView

+(WeAppBasicFieldView*)getSecurityFieldView;

+(WeAppBasicFieldView*)getCommonFieldView;

@property (strong, nonatomic) KSLineBorderTextField     *textView;

@property (strong, nonatomic) UIImageView               *backgroundImage;

@property (strong, nonatomic,getter = getText) NSString            *text;

@property (weak, nonatomic  ) id<UITextFieldDelegate> aDelegate;

@property (assign, nonatomic) UIEdgeInsets        textViewInsets;

@property (copy  , nonatomic) textValueDidChangedBlock textValueDidChanged;

@end
