//
//  EHHomeNavBarRightView.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@class HSMessageNavBarRightView;

typedef void (^doNavBarRightButtonClicedBlock)        (HSMessageNavBarRightView* EHHomeNavBarRightView);

@interface HSMessageNavBarRightView : KSView

@property (nonatomic, strong) UIButton              *btn;

@property (nonatomic, strong) UIImageView           *pointImage;

@property (nonatomic, copy  ) doNavBarRightButtonClicedBlock    buttonClickedBlock;

-(void)setupPointImageStatusWithNumber:(NSNumber*)number;

+ (instancetype)sharedCenter;

@end
