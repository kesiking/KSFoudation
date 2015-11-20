//
//  HSBusinessUserListViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoEditViewController.h"
#import "HSBusinessUserInfoModifyService.h"
#import "WeAppBasicFieldView.h"

#define kFieldViewMaxTextNumber (20)

@interface HSBusinessUserInfoEditViewController ()

@property (nonatomic, strong) WeAppBasicFieldView               *userNickNameFieldView;

@property (nonatomic, strong) HSBusinessUserInfoModifyService   *businessUserInfoModifyService;

@property (nonatomic, strong) NSString                          *userPhone;

@property (nonatomic, strong) NSString                          *userNickName;

@property (nonatomic, strong) NSString                          *userTrueName;

@property (nonatomic, strong) NSString                          *appId;

@end

@implementation HSBusinessUserInfoEditViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.userPhone = [nativeParams objectForKey:@"userPhone"];
        self.userNickName = [nativeParams objectForKey:@"userNickName"];
        self.userTrueName = [nativeParams objectForKey:@"userTrueName"];
        self.appId = [nativeParams objectForKey:@"appId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    [self initNavigationRightButton];
    [[self userNickNameFieldView] setText:self.userNickName];
}

- (void)setupViewController{
    self.title = @"修改昵称";
    self.view.backgroundColor = EHBgcor1;
}

// 创建右导航按钮
-(void)initNavigationRightButton{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(editDone:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

// 创建输入框
-(WeAppBasicFieldView *)userNickNameFieldView{
    if(_userNickNameFieldView == nil){
        _userNickNameFieldView = [WeAppBasicFieldView getCommonFieldView];
        [_userNickNameFieldView setFrame:CGRectMake(12, 12, self.view.width - 24, 44)];
        _userNickNameFieldView.textView.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        _userNickNameFieldView.textView.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        _userNickNameFieldView.textView.clearButtonMode = UITextFieldViewModeNever;

        _userNickNameFieldView.textView.placeholder = @"输入用户昵称";
        _userNickNameFieldView.textView.font = [UIFont systemFontOfSize:EHSiz2];
        _userNickNameFieldView.textView.textColor = EHCor5;
        
        [self.view addSubview:_userNickNameFieldView];
        
        WEAKSELF
        _userNickNameFieldView.textValueDidChanged = ^(UITextField* textView){
            STRONGSELF
            if (strongSelf.userNickNameFieldView.textView.markedTextRange == nil && strongSelf.userNickNameFieldView.textView.text.length > kFieldViewMaxTextNumber) {
                NSString *subString = [strongSelf.userNickNameFieldView.textView.text substringToIndex:kFieldViewMaxTextNumber];
                strongSelf.userNickNameFieldView.textView.text = subString;
            }
        };
        [_userNickNameFieldView.textView becomeFirstResponder];
    }
    return _userNickNameFieldView;
}

-(HSBusinessUserInfoModifyService *)businessUserInfoModifyService{
    if (_businessUserInfoModifyService == nil) {
        _businessUserInfoModifyService = [HSBusinessUserInfoModifyService new];
        WEAKSELF
        _businessUserInfoModifyService.serviceDidFinishLoadBlock = ^(WeAppBasicService *service) {
            STRONGSELF
            NSString *name = strongSelf.userNickNameFieldView.textView.text;
            if (name.length == 0) {
                return ;
            }
            
            name = [EHUtils trimmingHeadAndTailSpaceInstring:name];
            if (name.length > kFieldViewMaxTextNumber) {
                [WeAppToast toast:@"昵称长度超过最大长度!"];
                return;
            }
            
            if (strongSelf.modifyNickNameSuccess) {
                strongSelf.modifyNickNameSuccess(name);
            }
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _businessUserInfoModifyService.serviceDidFailLoadBlock = ^(WeAppBasicService *service,NSError *error){
            [WeAppToast toast:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        };
    }
    return _businessUserInfoModifyService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editDone:(id)sender{
    if ([EHUtils isEmptyString:self.userNickNameFieldView.text]) {
        [WeAppToast toast:@"昵称不能为空"];
    }else if(![EHUtils isValidString:self.userNickNameFieldView.text]){
        [WeAppToast toast:@"请输入正确格式的昵称"];
    }else{
        [self modifyUserNickName:self.userNickNameFieldView.text];
    }
}

- (void)modifyUserNickName:(NSString*)nickName{
    [self.businessUserInfoModifyService modifyBusinessUserInfoWithUserPhone:self.userPhone appId:self.appId nickName:nickName userTrueName:self.userTrueName];
}

@end
