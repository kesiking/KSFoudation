//
//  CBTextView.m
//  CBTextView
//
//  Created by ly on 13-9-18.
//  Copyright (c) 2013年 ly. All rights reserved.
//

#import "WeAppBasicTextView.h"
#import "WeAppConstant.h"

#define SHOW_DEBUG_VIEW     0

#define RGBAlphaColor(r, g, b, a) \
        [UIColor colorWithRed:(r/255.0)\
                        green:(g/255.0)\
                         blue:(b/255.0)\
                        alpha:(a)]

#define OpaqueRGBColor(r, g, b) RGBAlphaColor((r), (g), (b), 1.0)

@interface WeAppBasicTextView () <UITextViewDelegate>

@property (nonatomic, assign) BOOL textViewDidBringToFront;

@end

@implementation WeAppBasicTextView

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
    self.placeHolderColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    
    self.textViewInsets = UIEdgeInsetsMake(navigationHeight, 0, 0, 0);
        
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardWillHideNotification object:nil];
    
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
    self.textView.frame = aFrame;
    self.backgroundImage.frame = aFrame;
}

#pragma mark - Accessor
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textView.text = placeHolder;
    self.textView.textColor = self.placeHolderColor;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    self.textView.textColor = placeHolderColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    defaultTextColor = self.textView.textColor;
    self.textView.textColor = textColor;
}

- (void)setADelegate:(id)aDelegate
{
    _aDelegate = aDelegate;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //返回键的类型
        _textView.returnKeyType = UIReturnKeyDefault;
        
        //键盘类型
        _textView.keyboardType = UIKeyboardTypeDefault;
        
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
        
        [_textView setInputAccessoryView:topView];
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
        _backgroundImage.backgroundColor = [UIColor whiteColor];
        _backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backgroundImage;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.aDelegate textViewShouldBeginEditing:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.aDelegate textViewShouldEndEditing:textView];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = _prevText;
    self.textView.textColor = defaultTextColor;
    
    if ([self.aDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.aDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _prevText = self.textView.text;
    if (!_prevText || [_prevText length]==0) {
        self.textView.text = self.placeHolder;
        self.textView.textColor = self.placeHolderColor;
    }
    
    if ([self.aDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.aDelegate textViewDidEndEditing:textView];
    }
    
    [self keyboardDidHidden];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.aDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.aDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.aDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.aDelegate textViewDidChangeSelection:textView];
    }
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
    [UIView commitAnimations];
}

#pragma mark-
#pragma mark- override hitTest:hitEvent: method

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 如果点击事件在currentSectionView中，则指定currentSectionView为响应对象
    CGPoint hitPoint = [self convertPoint:point fromView:self];
    BOOL isTextViewInsideHitPoint = CGRectContainsPoint(self.textView.frame, hitPoint);
    if (isTextViewInsideHitPoint && [self.textView isFirstResponder]) {
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