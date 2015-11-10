//
//  WeAppBasicFieldView.m
//  WeAppSDK
//
//  Created by 逸行 on 14-12-25.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "WeAppBasicFieldView.h"
#import "WeAppBasicTextView.h"
#import "WeAppConstant.h"

@interface WeAppBasicFieldView () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL textViewDidBringToFront;

@end

@implementation WeAppBasicFieldView

+(WeAppBasicFieldView*)getSecurityFieldView{
    WeAppBasicFieldView* securityFieldView = [[WeAppBasicFieldView alloc] init];
    securityFieldView.textView.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [securityFieldView.textView setFont:[UIFont boldSystemFontOfSize:EHSiz2]];
    [securityFieldView.textView setTextColor:[UIColor colorWithWhite:0x33/255.0 alpha:1]];
    [securityFieldView.textView setValue:[UIColor colorWithWhite:0xdc/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    securityFieldView.textView.colorWhileEditing = [UIColor clearColor];
    securityFieldView.textView.colorNotEditing = [UIColor clearColor];
    securityFieldView.textView.borderStyle = UITextBorderStyleRoundedRect;
    securityFieldView.textView.keyboardType = UIKeyboardTypeNamePhonePad;
    securityFieldView.textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    securityFieldView.textView.secureTextEntry = YES;
    securityFieldView.backgroundColor = [UIColor clearColor];
    securityFieldView.textView.isSecurityField = YES;
    return securityFieldView;
}

+(WeAppBasicFieldView*)getCommonFieldView{
    WeAppBasicFieldView* commonFieldView = [[WeAppBasicFieldView alloc] init];
    commonFieldView.textView.borderStyle = UITextBorderStyleRoundedRect;
    commonFieldView.textView.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [commonFieldView.textView setFont:[UIFont boldSystemFontOfSize:16]];
    [commonFieldView.textView setTextColor:[UIColor colorWithWhite:0x33/255.0 alpha:1]];
    [commonFieldView.textView setValue:[UIColor colorWithWhite:0xdc/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    commonFieldView.textView.colorWhileEditing = [UIColor clearColor];
    commonFieldView.textView.colorNotEditing = [UIColor clearColor];

    commonFieldView.textView.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    commonFieldView.textView.keyboardType = UIKeyboardTypeNamePhonePad;
    commonFieldView.textView.clearButtonMode = UITextFieldViewModeAlways;
    commonFieldView.textView.secureTextEntry = NO;
    commonFieldView.backgroundColor = [UIColor clearColor];
    return commonFieldView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.backgroundImage];
    [self addSubview:self.textView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.textView.delegate = self;
    
    self.textViewInsets = UIEdgeInsetsMake(navigationHeight, 0, 0, 0);
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];;
    
#if SHOW_DEBUG_VIEW
    self.textView.backgroundColor = DEBUG_VIEW_ITEM_COLOR;
    self.backgroundColor = DEBUG_VIEW_CONTAINER_COLOR;
#endif
}

-(void)dealloc{
    //注销监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignKeyboard];
    self.textView.delegate = nil;
}

#pragma mark - Layout
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect aFrame = CGRectZero;
    aFrame.origin = self.bounds.origin;
    aFrame.size = frame.size;
    if (![self.textView isFirstResponder]) {
        self.textView.frame = aFrame;
        self.backgroundImage.frame = aFrame;
    }
//    self.textView.rightView.frame = CGRectMake(self.textView.rightView.frame.origin.x, self.textView.rightView.frame.origin.y, self.textView.rightView.frame.size.width, aFrame.size.height);
//    self.textView.leftView.frame = CGRectMake(self.textView.leftView.frame.origin.x, self.textView.leftView.frame.origin.y, self.textView.leftView.frame.size.width, aFrame.size.height);

}

- (void)setADelegate:(id)aDelegate
{
    _aDelegate = aDelegate;
}

-(void)setText:(NSString *)text{
    _textView.text = text;
    if (text != nil && text.length > 0) {
        self.textView.isTextEditing = YES;
    }
    if (self.textValueDidChanged) {
        self.textValueDidChanged(self.textView);
    }
}

-(NSString*)getText{
    return _textView.text;
}

- (KSLineBorderTextField *)textView
{
    if (_textView == nil) {
        _textView = [[KSLineBorderTextField alloc] init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.secureTextEntry = NO;
        _textView.clearsOnBeginEditing = NO;
        _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
        //返回键的类型
        _textView.returnKeyType = UIReturnKeyDone;
        //键盘类型
        _textView.keyboardType = UIKeyboardTypeDefault;
        
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

//隐藏键盘
- (void)resignKeyboard {
    [self.textView resignFirstResponder];
}

-(UIImageView *)backgroundImage{
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.backgroundColor = [UIColor clearColor];
        _backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backgroundImage;
}

-(void)bringViewToFront:(UIView *)view{
    if (view == nil) {
        return;
    }
    UIView* superView = view.superview;
    UIView* subView = view;
    // 向上递归寻找父view
    // 将view的剪裁属性设置为NO，超出父view可见
    // 将需要吸顶的view放到最顶层保持可见
    while (superView != nil && [superView isKindOfClass:[UIView class]] && superView != self.viewController.view) {
        [superView setClipsToBounds:NO];
        [superView bringSubviewToFront:subView];
        subView = superView;
        superView = subView.superview;
    }
    if (subView) {
        [self.viewController.view bringSubviewToFront:subView];
    }
}

#pragma mark - UITextFieldDelegate

-(void)textFieldChanged:(NSNotification *)notification{
    UITextField* textField = [notification object];
    if ([textField isKindOfClass:[KSLineBorderTextField class]]) {
        if (textField.text.length > 0){
            ((KSLineBorderTextField*)textField).isTextEditing = YES;
        }else{
            ((KSLineBorderTextField*)textField).isTextEditing = NO;
        }
    }
    if (textField && self.textValueDidChanged) {
        self.textValueDidChanged(textField);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.aDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.aDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.aDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.aDelegate textFieldDidEndEditing:textField];
    }
    [self keyboardDidHidden];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.aDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.aDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignKeyboard];
    return YES;
}

#pragma mark - Actions
- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    // 如果textView不是第一响应者不需要响应
    if (![self.textView isFirstResponder]) {
        return;
    }
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    
    UIView* referenceView = [[UIApplication sharedApplication] keyWindow];
    CGRect visibleViewRect = [self.textView convertRect:self.textView.bounds toView:referenceView];
    CGFloat visibleOringeY = MAX(CGRectGetMinY(visibleViewRect), 0);
    CGFloat visibleHeight  = MAX(CGRectGetMaxY(visibleViewRect), 0);
    
    // 计算textView的真正窗口高度，在self.frame.size.height与keyboardRemainHeight高度之间取小值
    CGFloat textViewRealHeight = textViewHeight(self.frame.size.height,keyboardRect.size.height);
    
    // 根据当前self.textView的底部位置映射到屏幕上后的位置与keyboardRemainHeight作比较，计算出偏移量
    CGFloat offset = visibleHeight - (keyboardRemainHeight(keyboardRect.size.height) + self.textViewInsets.top + self.textViewInsets.bottom);
    
    // 如果textView的真正窗口高度大于keyboard弹起后窗口剩余的高度(不等于self.frame.size.height)，则在可展示窗口展示全部textView，并在头部置于指定位置J
    if (textViewRealHeight != self.frame.size.height) {
        [self bringViewToFront:self.textView];
        [self.textView setFrame:CGRectMake(0, self.textViewInsets.top - visibleOringeY, self.textView.frame.size.width, textViewRealHeight)];
    }else if (offset > 0) {
        //设置view的frame，往上平移
        [self bringViewToFront:self.textView];
        [self.textView setFrame:CGRectMake(0,  -offset, self.textView.frame.size.width, textViewHeight(self.frame.size.height,keyboardRect.size.height))];
    }else{
        //设置view的frame，往上平移
        [self.textView setFrame:CGRectMake(0, 0, self.textView.frame.size.width, textViewHeight(self.frame.size.height,keyboardRect.size.height))];
    }
    [self.backgroundImage setFrame:self.textView.frame];
    [UIView commitAnimations];
}

//键盘消失时
-(void)keyboardDidHidden
{
    // 如果textView不是第一响应者不需要响应
    if (![self.textView isFirstResponder]
        && CGRectEqualToRect(self.textView.frame, self.bounds)) {
        return;
    }
    
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [self.textView setFrame:CGRectMake(0, 0, self.textView.frame.size.width, self.frame.size.height)];
    [self.backgroundImage setFrame:self.textView.frame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

#pragma mark-
#pragma mark- override hitTest:hitEvent: method

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 如果点击事件在currentSectionView中，则指定currentSectionView为响应对象
    CGPoint hitPoint = [self convertPoint:point fromView:self];
    BOOL isTextViewInsideHitPoint = CGRectContainsPoint(self.textView.frame, hitPoint);
    if (isTextViewInsideHitPoint && [self.textView isFirstResponder]) {
        BOOL isleftViewInsideHitPoint = NO;
        UIView *leftView = self.textView.leftView;
        if (leftView) {
            // 坐标转换
            CGPoint leftViewHitPoint = [self.textView convertPoint:hitPoint fromView:self];
            isleftViewInsideHitPoint = CGRectContainsPoint(leftView.frame, leftViewHitPoint);
            if (isleftViewInsideHitPoint) {
                return leftView;
            }
        }
        BOOL isrightViewInsideHitPoint = NO;
        UIView *rightView = self.textView.rightView;
        if (rightView) {
            // 坐标转换
            CGPoint rightViewHitPoint = [self.textView convertPoint:hitPoint fromView:self];
            isrightViewInsideHitPoint = CGRectContainsPoint(rightView.frame, rightViewHitPoint);
            if (isrightViewInsideHitPoint) {
                return rightView;
            }
        }
        // 判断如果是点击了删除按钮 则isClearButtonInsideHitPoint为YES，删除按钮响应事件
        BOOL isClearButtonInsideHitPoint = NO;
        @try {
            // KVC 获取clearButton 删除按钮，考虑到可能跟版本有关（依赖于系统），因此加上try cache
            UIButton *clearButton = [self.textView valueForKey:@"_clearButton"];
            if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
                // 坐标转换
                CGPoint clearButtonHitPoint = [self.textView convertPoint:hitPoint fromView:self];
                isClearButtonInsideHitPoint = CGRectContainsPoint(clearButton.frame, clearButtonHitPoint);
                if (isClearButtonInsideHitPoint) {
                    return clearButton;
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"get clearButton crashed");
        }
        // 否则textView响应所有事件
        return self.textView;
    }
    UIView* referenceView = [[UIApplication sharedApplication] keyWindow];
    CGPoint windowPoint = [self convertPoint:point toView:referenceView];
    CGRect keyboardOringeRect = CGRectMake(0, referenceView.frame.size.height - 216,referenceView.frame.size.width,216);
    if (!CGRectContainsPoint(keyboardOringeRect, windowPoint)) {
        [self resignKeyboard];
    }
    return [super hitTest:point withEvent:event];
}

@end
