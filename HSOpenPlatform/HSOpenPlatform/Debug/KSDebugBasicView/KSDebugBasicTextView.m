//
//  WeAppDebugBasicTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-4.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugBasicTextView.h"

#define kAnimationDuration 0.2

#define kViewHeight 200
#define navigationHeight (64)
#define toolBarHeight (44)
#define keyboardRemainHeight(keyboardHeight) ([[UIScreen mainScreen] bounds].size.height - keyboardHeight)
#define textViewHeight(viewHeight,keyboardHeight) MIN(viewHeight,keyboardRemainHeight(keyboardHeight))

@interface KSDebugBasicTextView()

@property(nonatomic, strong)  UILabel *   infoLabel;
@property(nonatomic, assign)  CGRect      debugTextViewFrame;

@end

@implementation KSDebugBasicTextView


-(void)setupView{
    [super setupView];
    
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.hidden = YES;
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignKeyboard];
    _debugTextView.delegate = nil;
    _debugTextView = nil;
}

-(UITextView *)debugTextView{
    if (_debugTextView == nil) {
        _debugTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.infoLabel.frame.origin.x, CGRectGetMaxY(self.infoLabel.frame) + 2, self.infoLabel.frame.size.width, self.frame.size.height - 20 * 2 - 40 * 2)];
        self.debugTextViewFrame = _debugTextView.frame;
        _debugTextView.layer.masksToBounds = YES;
        _debugTextView.layer.cornerRadius = 10;
        _debugTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _debugTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _debugTextView.returnKeyType = UIReturnKeyDefault;
        
        //键盘类型
        _debugTextView.keyboardType = UIKeyboardTypeDefault;
        
        //定义一个toolBar
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        //设置style
        [topView setBarStyle:UIBarStyleDefault];
        
        //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
        UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        //定义完成按钮
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
        
        //在toolBar上加上这些按钮
        NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
        [topView setItems:buttonsArray];
        
        [_debugTextView setInputAccessoryView:topView];
    }
    return _debugTextView;
}

-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 20 * 2, 40)];
        [_infoLabel setBackgroundColor:[UIColor blackColor]];
        [_infoLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_infoLabel setTextColor:[UIColor whiteColor]];
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.layer.cornerRadius = 10;
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setText:@"debug"];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

-(void)closeButtonDidSelect{
    
}

//隐藏键盘
- (void)resignKeyboard {
    [_debugTextView resignFirstResponder];
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    
    if (self.debugTextView.superview == nil) {
        [self.debugTextView setHidden:NO];
        [self addSubview:self.debugTextView];
        [self.closeButton setHidden:NO];
        [self.closeButton setFrame:CGRectMake(self.debugTextView.frame.origin.x, CGRectGetMaxY(self.debugTextView.frame) + 2, CGRectGetWidth(self.debugTextView.frame), 40)];
        self.closeButton.backgroundColor = [UIColor blackColor];
        [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    }
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
}

-(void)generateStringToDebugTextViewWithDictionary:(NSDictionary*)dict{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.debugTextView.text = [self generateStringWithDictionary:dict];
}

-(NSString*)generateStringWithDictionary:(NSDictionary*)dict{
    if (dict == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

-(NSString*)generateStringWithArray:(NSArray*)array{
    if (array == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

-(void)setTitleInfoText:(NSString*)titleInfoText{
    [self.infoLabel setText:titleInfoText];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    // 如果textView不是第一响应者不需要响应
    if (![self.debugTextView isFirstResponder]) {
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
    CGRect visibleViewRect = [self.debugTextView convertRect:self.debugTextView.bounds toView:referenceView];
    CGFloat visibleOringeY = MAX(CGRectGetMinY(visibleViewRect), 0);
    CGFloat visibleHeight  = MAX(CGRectGetMaxY(visibleViewRect), 0);
    
    // 计算textView的真正窗口高度，在self.frame.size.height与keyboardRemainHeight高度之间取小值
    CGFloat textViewRealHeight = textViewHeight(self.frame.size.height,keyboardRect.size.height);
    
    // 根据当前self.textView的底部位置映射到屏幕上后的位置与keyboardRemainHeight作比较，计算出偏移量
    CGFloat offset = visibleHeight - (keyboardRemainHeight(keyboardRect.size.height));
    
    // 如果textView的真正窗口高度大于keyboard弹起后窗口剩余的高度(不等于self.frame.size.height)，则在可展示窗口展示全部textView，并在头部置于指定位置J
    if (textViewRealHeight != self.frame.size.height) {
        [self.debugTextView setFrame:CGRectMake(self.infoLabel.frame.origin.x, 44 - visibleOringeY, self.frame.size.width, textViewRealHeight)];
    }else if (offset > 0) {
        //设置view的frame，往上平移
        [self.debugTextView setFrame:CGRectMake(self.infoLabel.frame.origin.x,  44 -offset, self.frame.size.width, textViewHeight(self.frame.size.height,keyboardRect.size.height))];
    }else{
        //设置view的frame，往上平移
        [self.debugTextView setFrame:CGRectMake(self.infoLabel.frame.origin.x, 44, self.frame.size.width, textViewHeight(self.frame.size.height,keyboardRect.size.height))];
    }
    [UIView commitAnimations];
}

//键盘消失时
-(void)keyboardDidHidden
{
    // 如果textView不是第一响应者不需要响应
    if (![self.debugTextView isFirstResponder]
        && CGRectEqualToRect(self.debugTextView.frame, self.bounds)) {
        return;
    }
    
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [self.debugTextView setFrame:self.debugTextViewFrame];
    [UIView commitAnimations];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint hitPoint = [self convertPoint:point fromView:self];
    BOOL isTextViewInsideHitPoint = CGRectContainsPoint(self.debugTextView.frame, hitPoint);
    if (isTextViewInsideHitPoint) {
        return self.debugTextView;
    }
    return [super hitTest:point withEvent:event];
}

@end
