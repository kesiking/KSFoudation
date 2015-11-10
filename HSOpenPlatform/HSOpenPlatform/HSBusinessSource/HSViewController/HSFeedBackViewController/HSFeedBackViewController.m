//
//  ManWuFeedBackViewController.m
//  basicFoundation
//
//  Created by 许学 on 15/5/20.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "HSFeedBackViewController.h"


@interface HSFeedBackViewController ()<UITextViewDelegate,WeAppBasicServiceDelegate>

@end

@implementation HSFeedBackViewController

-(KSAdapterService *)service{
    if (_service == nil) {
        _service = [[KSAdapterService alloc] init];
        _service.delegate = self;
    }
    return _service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.btn_commit];
}

- (UITextView *)textView
{
    if(_textView == nil)
    {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(kSpaceX, 30, SCREEN_WIDTH - 2 * kSpaceX, 180)];
        _textView.keyboardType = UIKeyboardTypeNamePhonePad;
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor = RGB(0x99, 0x99, 0x99).CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textColor = RGB(0x33, 0x33, 0x33);
        _textView.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)btn_commit
{
    if(_btn_commit == nil)
    {
        _btn_commit = [[UIButton alloc]initWithFrame:CGRectMake(kSpaceX, CGRectGetMaxY(_textView.frame) + 60, SCREEN_WIDTH - 2 * kSpaceX, 40)];
        [_btn_commit setTitle:@"提交" forState:UIControlStateNormal];
        [_btn_commit.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_btn_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_commit setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_btn_commit setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
        [_btn_commit addTarget:self action:@selector(doFeedBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_commit;
}

#pragma mark 监听View点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

- (void)doFeedBack
{
    if ([EHUtils isEmptyString:[KSAuthenticationCenter userPhone]]) {
        [WeAppToast toast:@"用户userPhone不可为空"];
        return;
    }
    if ([EHUtils isEmptyString:_textView.text]) {
        [WeAppToast toast:@"请输入反馈内容"];
        return;
    }
    
    NSMutableDictionary* userFeedbackDict = [NSMutableDictionary dictionary];
    [userFeedbackDict setObject:[KSAuthenticationCenter userPhone] forKey:@"userPhone"];
    [userFeedbackDict setObject:_textView.text forKey:@"feedBackMsg"];
    if ([HSDeviceDataCenter appShortVersion]) {
        [userFeedbackDict setObject:[HSDeviceDataCenter appShortVersion] forKey:@"currentAppVersion"];
    }
    NSString* currentTime = [[HSDateManagerCenter sharedCenter] currentTime];
    if (currentTime) {
        [userFeedbackDict setObject:currentTime forKey:@"dateTime"];
    }
    NSString* userFeedback = [WeAppUtils getJSONStringWithDictionary:userFeedbackDict];
    
    [self.service loadItemWithAPIName:kHSSendFeedbackApiName params:@{@"userPhone":[KSAuthenticationCenter userPhone],@"userFeedback":userFeedback?:@""} version:nil];
}

-(void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

#pragma mark WeAppBasicServiceDelegate method

- (void)serviceDidStartLoad:(WeAppBasicService *)service
{
    if (service == _service) {
        // todo success
    }
}

- (void)serviceDidFinishLoad:(WeAppBasicService *)service
{
    if (service == _service) {
        // todo success
        [WeAppToast toast:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)service:(WeAppBasicService *)service didFailLoadWithError:(NSError*)error{
    if (service == _service) {
        // todo fail
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        [WeAppToast toast:errorInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
