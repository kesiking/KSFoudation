//
//  KSLineBorderTextField.h
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSInsetsTextField.h"

@interface KSLineBorderTextField : KSInsetsTextField

@property (nonatomic, assign) BOOL         isSecurityField;

@property (nonatomic, assign) BOOL         isTextEditing;

@property (nonatomic, strong) UIColor     *colorNotEditing;

@property (nonatomic, strong) UIColor     *colorWhileEditing;

@property (nonatomic, strong) UIImage     *rightNormalImage;

@property (nonatomic, strong) UIImage     *rightSelectImage;

@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;

@end
