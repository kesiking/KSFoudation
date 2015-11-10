//
//  KSInsetsTextField.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSInsetsTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets       textEdgeInsets;

@property (nonatomic, assign) UIEdgeInsets       leftViewEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets       rightViewEdgeInsets;

@property (nonatomic, assign) UIEdgeInsets       clearButtonEdgeInsets;

@end
