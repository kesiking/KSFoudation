//
//  KSRegisterView.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSRegisterViewCtl.h"
#import "KSLoginService.h"

typedef void (^registerActionBlock)(BOOL registerSuccess);

typedef void (^cancelActionBlock)(void);

@interface KSRegisterView : KSView{
    KSRegisterViewCtl    *_registerViewCtl;
    KSLoginService       *_checkAccountNameService;
}


// 视觉控件集合
@property (nonatomic, strong,setter=setRegisterViewCtl:,getter=getRegisterViewCtl) KSRegisterViewCtl     *registerViewCtl;

@property (nonatomic, strong,setter=setCheckAccountNameService:,getter=getCheckAccountNameService) KSLoginService        *checkAccountNameService;

// 回调函数
@property (nonatomic, copy) registerActionBlock   registerActionBlock;

@property (nonatomic, copy) cancelActionBlock     cancelActionBlock;

-(void)reloadData;

@end
