//
//  EHModifyNickNameViewController.m
//  eHome
//
//  Created by xtq on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyNickNameViewController.h"
#import "EHModifyNickNameService.h"
#import "EHLoadingHud.h"
#import "EHUtils.h"

#define EHPersonNameLength 20
#define EHOtherNameLength 10

@interface EHModifyNickNameViewController()<UITextFieldDelegate>

@end

@implementation EHModifyNickNameViewController
{
    NSString *_nickName;
    NSString *_sendNickName;
    UIButton *_sureBtn;
    UITextField *_nickNameField;
    EHModifyNickNameService *_modifyNickNameService;
}

-(instancetype)initWithNickName:(NSString *)nickName{
    self = [super init];
    if (self) {
        _nickName = nickName;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:[self sureBtn]];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.title = @"我的昵称";
    [self.view addSubview:[self nickNameField]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [_nickNameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Events Response
- (void)sureBtnClick:(id)sender{
    [_nickNameField resignFirstResponder];
    NSString*nickName = [EHUtils trimmingHeadAndTailSpaceInstring:_nickNameField.text];
    _nickNameField.text = nickName;
    
    if (nickName.length > EHPersonNameLength) {
        [WeAppToast toast:(@"昵称超过最大长度!")];
        return;
    }
    
    if ([EHUtils isEmptyString:nickName]) {
        nickName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    
    _sendNickName = nickName;
    
    if ([_sendNickName isEqualToString:_nickName]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.statusHandler showLoadingViewInView:self.view];
        [self setService];
        [_modifyNickNameService modifyNickNameWithUserPhone:[KSLoginComponentItem sharedInstance].user_phone nickName:_sendNickName];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - Getters And Setters
- (UITextField *)nickNameField{
    if (!_nickNameField) {
        _nickNameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, CGRectGetWidth(self.view.frame) - 40, 50)];
        _nickNameField.borderStyle = UITextBorderStyleRoundedRect;
        _nickNameField.placeholder = @"昵称";
        _nickNameField.text = _nickName;
        _nickNameField.returnKeyType = UIReturnKeyDone;
        _nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameField.delegate = self;
    }
    return _nickNameField;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:EHCor6 forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)setService{
    if (!_modifyNickNameService) {
        _modifyNickNameService = [EHModifyNickNameService new];
        WEAKSELF
        NSString * __weak weakNickName = _sendNickName;
        NSLog(@"weakNickName = %@",weakNickName);
        _modifyNickNameService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf.statusHandler hideLoadingView];
            [KSLoginComponentItem sharedInstance].nick_name = weakNickName;
            !strongSelf.modifyNickNameSuccess?:strongSelf.modifyNickNameSuccess();
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _modifyNickNameService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [weakSelf.statusHandler hideLoadingView];
            [WeAppToast toast:@"昵称修改失败！"];
        };
    }
}

@end
