//
//  HSBusinessUserInfoEditAlertView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/17.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoEditAlertView.h"
#import "HSBusinessUserInfoModifyService.h"

#define kFieldViewMaxTextNumber (20)

@interface HSBusinessUserInfoEditAlertView ()

@property (nonatomic, strong) HSBusinessUserInfoModifyService   *businessUserInfoModifyService;

@end

@implementation HSBusinessUserInfoEditAlertView

-(void)config{
    [super config];
    self.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [self getTextField];
    if (textField) {
        textField.placeholder = @"输入用户昵称";
    }
}

-(void)setUserNickName:(NSString *)userNickName{
    _userNickName = userNickName;
    if (userNickName) {
        [[self getTextField] setText:userNickName];
    }
}

-(void)setUserTrueName:(NSString *)userTrueName{
    _userTrueName = userTrueName;
    [[self getTextField] setText:userTrueName];
}

-(HSBusinessUserInfoModifyService *)businessUserInfoModifyService{
    if (_businessUserInfoModifyService == nil) {
        _businessUserInfoModifyService = [HSBusinessUserInfoModifyService new];
        [self setService:_businessUserInfoModifyService];
    }
    return _businessUserInfoModifyService;
}

-(UITextField*)getTextField{
    return [self textFieldAtIndex:0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    UITextField* textField = [self getTextField];
    if (buttonIndex != 0) {
        if ([EHUtils isEmptyString:textField.text]) {
            [self toastMessage:@"昵称不能为空"];
        }else if(textField.text.length > 20){
            [self toastMessage:@"昵称超过最大长度!"];
        }else if(![EHUtils isValidString:textField.text]){
            [self toastMessage:@"请输入正确格式的昵称"];
        }else{
            [self modifyUserNickName:textField.text];
        }
    }
    textField.text = nil;
}

- (void)modifyUserNickName:(NSString*)nickName{
    nickName = [WeAppUtils trimWhitespaceAndNewlineCharacterWithString:nickName];
    self.businessUserInfoModifyService.serviceContext.serviceExtContextData = nickName;
    [self.businessUserInfoModifyService modifyBusinessUserInfoWithUserPhone:self.userPhone appId:self.appId nickName:nickName userTrueName:self.userTrueName];
}

- (void)serviceDidStartLoad:(WeAppBasicService *)service{
    [super serviceDidStartLoad:service];
}

- (void)serviceDidCancelLoad:(WeAppBasicService *)service{
    
}

- (void)serviceDidFinishLoad:(WeAppBasicService *)service{
    self.userNickName = service.serviceContext.serviceExtContextData;
    [super serviceDidFinishLoad:service];
}

- (void)service:(WeAppBasicService *)service didFailLoadWithError:(NSError*)error{
    [super service:service didFailLoadWithError:error];
}

-(void)dealloc{
    _businessUserInfoModifyService = nil;
}

@end
