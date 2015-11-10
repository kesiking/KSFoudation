//
//  KSLoginContent.h
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#ifndef eHome_KSLoginContent_h
#define eHome_KSLoginContent_h

#define loginFailCode      (1004)
#define loginFailDomain    @"login failed"

#define kLoginSuccessBlock @"loginSuccessBlock"
#define kLoginCancelBlock  @"loginCancelBlock"

typedef void (^loginActionBlock)(BOOL loginSuccess);
typedef void (^cancelActionBlock)(void);

#endif
