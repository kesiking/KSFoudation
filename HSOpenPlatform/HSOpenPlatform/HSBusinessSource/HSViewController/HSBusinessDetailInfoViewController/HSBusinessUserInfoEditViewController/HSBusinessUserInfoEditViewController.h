//
//  HSBusinessUserListViewController.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSViewController.h"

typedef void (^HSBusinessUserInfoModifyNickNameSuccess)(NSString* nickName);

@interface HSBusinessUserInfoEditViewController : KSViewController

@property(nonatomic,copy) HSBusinessUserInfoModifyNickNameSuccess modifyNickNameSuccess;

@end
