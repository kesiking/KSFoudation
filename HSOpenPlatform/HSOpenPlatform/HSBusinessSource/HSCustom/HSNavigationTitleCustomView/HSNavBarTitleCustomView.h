//
//  EHHomeNavBarTItleView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@class HSNavBarTitleCustomView;

typedef void (^doButtonClicedBlock)        (HSNavBarTitleCustomView* navBarTitleView);

@interface HSNavBarTitleCustomView : KSView

@property (nonatomic, strong) UIButton              *btn;

@property (nonatomic, strong) UIImageView           *imageView;

@property (nonatomic, strong) UIImage               *selectImage;

@property (nonatomic, strong) UIImage               *unSelectImage;

@property (nonatomic, assign) BOOL                   btnIsSelected;

@property (nonatomic, copy  ) doButtonClicedBlock    buttonClicedBlock;

-(void)setBtnTitle:(NSString*)title;

-(void)setButtonSelected:(BOOL)isSelected;

@end
