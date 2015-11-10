//
//  KSLoginHeader.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#ifndef basicFoundation_KSLoginHeader_h
#define basicFoundation_KSLoginHeader_h

#import "KSLoginComponentItem.h"
#import "KSAuthenticationCenter.h"
#import "KSLoginMaroc.h"
#import "KSLoginContentMaroc.h"
#import "KSLoginUrlPath.h"

#define UILOGINNAVIGATIONBAR_COLOR UINAVIGATIONBAR_COLOR
#define UILOGINNAVIGATIONBAR_TITLE_COLOR UINAVIGATIONBAR_TITLE_COLOR
#define UILOGINBUTTON_UNSELECT_COLOR RGB(0xdc,0xdc,0xdc)
#define UINEXTBUTTON_UNSELECT_COLOR  RGB_A(0xff,0xff,0xff,0.5)

#define UILOGINNAVIGATIONBAR_TITLE_SIZE UINAVIGATIONBAR_TITLE_SIZE


#define UILOGIN_NETWORK_ERROR_TITLE   UISYSTEM_NETWORK_ERROR_TITLE
#define UILOGIN_NETWORK_ERROR_MESSAGE UISYSTEM_NETWORK_ERROR_MESSAGE

#define KSLOGINCor3 RGB(0x99, 0x99, 0x99)
#define KSLOGINCor19 RGB(0x00, 0xcd, 0x44)
#define KSLOGINCor20 RGB_A(0x00, 0xcd, 0x44, 0.6)
#define KSLOGINBackgroundColor RGB(0xff, 0xff, 0xff)


/*!
 *  @author 孟希羲, 15-06-11 10:06:26
 *
 *  @brief  
    登陆可以使用        
    TBOpenURLFromSourceAndParams(loginURL, self, nil);
    修改密码可以使用
    TBOpenURLFromSourceAndParams(internalURL(kModifyPwdPage), self, nil);
    修改手机号码可以使用
    TBOpenURLFromSourceAndParams(internalURL(kModifyPhoneSecurityPage), self, nil);
 *
 *  @since
 */

#endif
