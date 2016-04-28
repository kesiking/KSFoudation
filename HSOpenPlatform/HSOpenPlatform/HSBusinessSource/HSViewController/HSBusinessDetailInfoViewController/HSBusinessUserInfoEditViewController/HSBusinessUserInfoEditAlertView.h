//
//  HSBusinessUserInfoEditAlertView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/17.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSServiceAlertView.h"

@interface HSBusinessUserInfoEditAlertView : HSServiceAlertView

@property (nonatomic, strong) NSString                          *userPhone;

@property (nonatomic, strong) NSString                          *memberPhone;

@property (nonatomic, strong) NSString                          *userNickName;

@property (nonatomic, strong) NSString                          *userTrueName;

@property (nonatomic, strong) NSNumber                          *productId;

@property (nonatomic, strong) NSNumber                          *deviceId;

-(UITextField*)getTextField;

@end
