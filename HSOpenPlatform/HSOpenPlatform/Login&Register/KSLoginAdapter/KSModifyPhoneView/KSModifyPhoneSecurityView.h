//
//  KSModifyPhoneSecurityView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "KSResetViewCtl.h"

@interface KSModifyPhoneSecurityView : KSView{
    KSResetViewCtl    *_securityViewCtl;
}

// 视觉控件集合
@property (nonatomic, strong,setter=setSecurityViewCtl:,getter=getSecurityViewCtl) KSResetViewCtl    *securityViewCtl;

@end
