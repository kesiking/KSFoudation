//
//  KSDebugLayoutInfoView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/3.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugLayoutInfoView.h"
#import "KSDebugPropertyButton.h"
#import "KSDebugUtils.h"
#import "UIView+Screenshot.h"
#import "KSDebugToastView.h"
#import "KSDebugUserDefault.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <wax/wax.h>

static char KSDebug_CALayerDisplayTimeKey;

@interface CALayer (KSDebug_CALayerDisplayTime)

-(void)KSDebug_CALayerDrawInContext:(CGContextRef)ctx;

-(void)KSDebug_CALayerRenderInContext:(CGContextRef)ctx;

-(void)KSDebug_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

-(void)setks_debug_CALayerDisplayTime:(NSNumber*)CALayerDisplayTime;

-(NSNumber*)ks_debug_CALayerDisplayTime;

@end

@implementation CALayer (KSDebug_CALayerDisplayTime)

-(void)KSDebug_CALayerRenderInContext:(CGContextRef)ctx{
    NSDate* currentDate = [NSDate date];
    [self KSDebug_CALayerRenderInContext:ctx];
    NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:currentDate] * 1000;
    [self setks_debug_CALayerDisplayTime:[NSNumber numberWithDouble:timerBucket]];
}

-(void)KSDebug_CALayerDrawInContext:(CGContextRef)ctx{
    NSDate* currentDate = [NSDate date];
    [self KSDebug_CALayerDrawInContext:ctx];
    NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:currentDate] * 1000;
    [self setks_debug_CALayerDisplayTime:[NSNumber numberWithDouble:timerBucket]];
}

- (void)KSDebug_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSDate* currentDate = [NSDate date];
    [self KSDebug_drawLayer:layer inContext:ctx];
    NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:currentDate] * 1000;
    [self setks_debug_CALayerDisplayTime:[NSNumber numberWithDouble:timerBucket]];
}

-(void)setks_debug_CALayerDisplayTime:(NSNumber*)CALayerDisplayTime{
    objc_setAssociatedObject(self, &KSDebug_CALayerDisplayTimeKey, CALayerDisplayTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber*)ks_debug_CALayerDisplayTime{
    return objc_getAssociatedObject(self, &KSDebug_CALayerDisplayTimeKey);
}

@end

static char KSDebug_UIViewDisplayTimeKey;

@interface UIView (KSDebug_UIViewDisplayTimeKey)

-(void)KSDebug_UIViewDrawRect:(CGRect)rect;

-(void)setks_debug_UIViewDisplayTime:(NSNumber*)CALayerDisplayTime;

-(NSNumber*)ks_debug_UIViewDisplayTime;

@end

@implementation UIView (KSDebug_UIViewDisplayTimeKey)

-(void)KSDebug_UIViewDrawRect:(CGRect)rect{
    NSDate* currentDate = [NSDate date];
    [self KSDebug_UIViewDrawRect:rect];
    NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:currentDate] * 1000;
    [self setks_debug_UIViewDisplayTime:[NSNumber numberWithDouble:timerBucket]];
}

- (void)KSDebug_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSDate* currentDate = [NSDate date];
    [self KSDebug_drawLayer:layer inContext:ctx];
    NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:currentDate] * 1000;
    [self setks_debug_UIViewDisplayTime:[NSNumber numberWithDouble:timerBucket]];
}

-(void)setks_debug_UIViewDisplayTime:(NSNumber*)CALayerDisplayTime{
    objc_setAssociatedObject(self, &KSDebug_UIViewDisplayTimeKey, CALayerDisplayTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber*)ks_debug_UIViewDisplayTime{
    return objc_getAssociatedObject(self, &KSDebug_UIViewDisplayTimeKey)?:[self.layer ks_debug_CALayerDisplayTime];
}

@end

#define KSDEBUG_PROPERTY_BUTTON_TAG  (11002)

@interface KSDebugLayoutInfoView()<UIActionSheetDelegate>

@property(nonatomic, strong)  UIImageView           *   selectViewTranslateToImageView;

@property(nonatomic, strong)  UITextField           *   scriptDebutTextView;

@property(nonatomic, strong)  UITextView            *   scriptOperationShowTextView;

@property(nonatomic, weak)    UIView                *   selectView;

@property(nonatomic, strong)  NSArray               *   viewArray;

@end

@implementation KSDebugLayoutInfoView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"布局信息",@"title",NSStringFromClass([self class]),@"className", nil]];
}

+(void)initialize{
    [self configTouch];
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_debug_swizzleSelector([UIView class], @selector(drawRect:), @selector(KSDebug_UIViewDrawRect:));
        ks_debug_swizzleSelector([UIView class], @selector(drawLayer:inContext:), @selector(KSDebug_drawLayer:inContext:));
        ks_debug_swizzleSelector([CALayer class], @selector(drawInContext:), @selector(KSDebug_CALayerDrawInContext:));
        ks_debug_swizzleSelector([CALayer class], @selector(renderInContext:), @selector(KSDebug_CALayerRenderInContext:));
        ks_debug_swizzleSelector([CALayer class], @selector(drawLayer:inContext:), @selector(KSDebug_drawLayer:inContext:));
        wax_start(nil, nil);
    });
}


-(void)setupView{
    [super setupView];
    
    self.backgroundColor = [UIColor clearColor];
    self.needCancelBackgroundAction = YES;
    [[self __getCancelButton] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
    [self setTitleInfoText:@"点击查看布局信息"];
    
    [self.debugTextView setSelectable:YES];
    [self.debugTextView setFont:[UIFont boldSystemFontOfSize:15]];
}

-(UIButton*)__getCancelButton{
    UIButton* cancelButton = [self valueForKey:@"cancelButton"];
    return cancelButton;
}

-(UIImageView *)selectViewTranslateToImageView{
    if (_selectViewTranslateToImageView == nil) {
        _selectViewTranslateToImageView = [[UIImageView alloc] init];
        [self addSubview:_selectViewTranslateToImageView];
    }
    return _selectViewTranslateToImageView;
}

-(UITextField *)scriptDebutTextView{
    if (_scriptDebutTextView == nil) {
        _scriptDebutTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.debugTextView.frame.origin.x, CGRectGetMaxY(self.debugTextView.frame) + 2, self.debugTextView.frame.size.width, 44)];
        _scriptDebutTextView.layer.masksToBounds = YES;
        _scriptDebutTextView.layer.cornerRadius = 10;
        _scriptDebutTextView.placeholder = @"请输入wax脚本，如sv:setBackgroundColor(UIColor:redColor())";
        //        _scriptDebutTextView.text = @"selectView:setBackgroundColor(UIColor:redColor())";
        _scriptDebutTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _scriptDebutTextView.returnKeyType = UIReturnKeyDefault;
        
        //键盘类型
        _scriptDebutTextView.keyboardType = UIKeyboardTypeDefault;
        
        //定义一个toolBar
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        //设置style
        [topView setBarStyle:UIBarStyleDefault];
        
        //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
        UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        //定义完成按钮
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignScriptDebutTextView)];
        
        //在toolBar上加上这些按钮
        NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
        [topView setItems:buttonsArray];
        
        [_scriptDebutTextView setInputAccessoryView:topView];
        
        [self addSubview:_scriptDebutTextView];
    }
    return _scriptDebutTextView;
}

-(UITextView *)scriptOperationShowTextView{
    if (_scriptOperationShowTextView == nil) {
        _scriptOperationShowTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.scriptDebutTextView.frame.origin.x, CGRectGetMaxY(self.scriptDebutTextView.frame) + 2, self.scriptDebutTextView.frame.size.width, 44)];
        _scriptOperationShowTextView.layer.masksToBounds = YES;
        _scriptOperationShowTextView.layer.cornerRadius = 10;
        _scriptOperationShowTextView.editable = NO;
        _scriptOperationShowTextView.text = @"脚本结果输出框";
        _scriptOperationShowTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _scriptOperationShowTextView.returnKeyType = UIReturnKeyDefault;
        
        //键盘类型
        _scriptOperationShowTextView.keyboardType = UIKeyboardTypeDefault;
        
        [self addSubview:_scriptOperationShowTextView];
    }
    return _scriptOperationShowTextView;
}

-(void)resignScriptDebutTextView{
    [self.scriptDebutTextView resignFirstResponder];
    [self runLuaStringWithScriptText:self.scriptDebutTextView.text withSelectView:self.selectView];
}

-(void)recurSetBackgroundColorWithView:(UIView*)view isRandom:(BOOL)random{
    if (view == nil
        || [view isKindOfClass:[KSDebugPropertyButton class]]
        //|| [view isKindOfClass:NSClassFromString(@"MAMapView")]
        || [NSStringFromClass([view class]) hasPrefix:@"KSDebug"]) {
        return;
    }
    
    if ([view isKindOfClass:NSClassFromString(@"RCTScrollView")]) {
        [KSDebugToastView toast:@"不能在RCTScrollView上添加子view，否则会crash" toView:self.debugViewReference displaytime:3];
        return;
    }
    
    KSDebugPropertyButton *propertyButton = (KSDebugPropertyButton*)[view viewWithTag:KSDEBUG_PROPERTY_BUTTON_TAG];
    if (propertyButton == nil) {
        propertyButton = [[KSDebugPropertyButton alloc] initWithFrame:view.bounds];
        [propertyButton setBackgroundColor:[UIColor clearColor]];
        propertyButton.exclusiveTouch = YES;
        propertyButton.tag = KSDEBUG_PROPERTY_BUTTON_TAG;
        [propertyButton addTarget:self action:@selector(checkComponentInfo:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(propertyButtonLongClicked:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [propertyButton addGestureRecognizer:longPress];
        propertyButton.referenceView = view;
        [propertyButton.dictObject setObject:@(view.userInteractionEnabled) forKey:@"userInteractionEnabled"];
        view.userInteractionEnabled = YES;
        [view insertSubview:propertyButton atIndex:0];
    }
    
    if (random) {
        int selectColor = arc4random() % 3;
        
        float red = selectColor == 0 ? 255.0 : 0.0;
        float blue = selectColor == 1 ? 255.0 : 0.0;
        float green = selectColor == 2 ?255.0 : 0.0;
        
        propertyButton.layer.borderWidth = 1.0;
        propertyButton.layer.borderColor = [[UIColor alloc]initWithRed:red / 255.0 green:green / 255.0 blue:blue/255.0 alpha:1].CGColor;
        propertyButton.layer.masksToBounds = YES;
    }else{
        propertyButton.layer.borderWidth = 1.0;
        propertyButton.layer.borderColor = [UIColor clearColor].CGColor;
        propertyButton.layer.masksToBounds = YES;
    }
    
    for (UIView *subView in view.subviews) {
        [self recurSetBackgroundColorWithView:subView isRandom:random];
    }
}

-(void)recurRemovePropertyButtonWithView:(UIView*)view{
    if (view == nil ) {
        return;
    }
    
    KSDebugPropertyButton *propertyButton = (KSDebugPropertyButton*)[view viewWithTag:KSDEBUG_PROPERTY_BUTTON_TAG];
    [propertyButton.referenceView setUserInteractionEnabled:[[propertyButton.dictObject objectForKey:@"userInteractionEnabled"] boolValue]];
    propertyButton.referenceView = nil;
    propertyButton.hidden = YES;
    [propertyButton removeFromSuperview];
    propertyButton = nil;
    
    for (UIView *subView in view.subviews) {
        [self recurRemovePropertyButtonWithView:subView];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   KSDebugPropertyButton clicked action method
-(void)checkComponentInfo:(KSDebugPropertyButton*)button{
    UIView* view = button.referenceView;
    if (view == nil) {
        return;
    }
    
    NSString* componentStr = [self getComponentViewInfoWithView:view];
    self.debugTextView.text = componentStr;
    [self showComponentViewWithAnimation:view];
    [self showCurrentView:YES];
}

-(void)propertyButtonLongClicked:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSLog(@"长按事件");
        UIView* selectView = gestureRecognizer.view;
        self.viewArray = [KSDebugUtils getAllSuperViewArrayWithView:selectView];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择想看的视图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        __block BOOL isViewArrayLegal = YES;
        
        [self.viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@_%p",NSStringFromClass([obj class]), obj]];
            }else{
                isViewArrayLegal = NO;
            }
        }];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        if (isViewArrayLegal) {
            [actionSheet showFromRect:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100) inView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }else{
            [KSDebugToastView toast:@"视图列表出错啦，请找程序员查看！"];
        }
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   component view 信息
-(NSString*)getComponentViewInfoWithView:(UIView*)view{
    if (view != self.selectView) {
        self.selectView = view;
    }
    NSString* componentStr = [NSString string];
    componentStr = [componentStr stringByAppendingFormat:@"-----------布局信息------------- \n"];
    /*
     * 获取viewController的基本信息
     */
    /**********************/
    UIViewController* currentViewController = [KSDebugUtils getViewController:view];
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------viewController的布局信息------------- \n"];
    componentStr = [componentStr stringByAppendingFormat:@"描述信息 : %@ \n",[currentViewController description]];
    /**********************/
    
    /*
     * 获取view的基本信息
     */
    /**********************/
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------view的布局信息------------- \n"];
    componentStr = [componentStr stringByAppendingFormat:@"viewClass : %@ \n",NSStringFromClass([view class])];
    if ([view ks_debug_UIViewDisplayTime]) {
        componentStr = [componentStr stringByAppendingFormat:@"渲染时间 : %@ ms \n",[view ks_debug_UIViewDisplayTime]];
    }
    componentStr = [componentStr stringByAppendingFormat:@"位置宽高 : %@ \n",NSStringFromCGRect(view.frame)];
    componentStr = [componentStr stringByAppendingFormat:@"背景颜色 : %@ \n",view.backgroundColor];
    componentStr = [componentStr stringByAppendingFormat:@"描述信息 : %@ \n",[view description]];
    /**********************/
    
    /*
     * 获取view的superView信息
     */
    /**********************/
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------父view的布局信息------------- \n"];
    if (view.superview) {
        componentStr = [componentStr stringByAppendingFormat:@"superviewClass : %@ \n",NSStringFromClass([view.superview class])];
        componentStr = [componentStr stringByAppendingFormat:@"superview的位置宽高 : %@ \n",NSStringFromCGRect(view.superview.frame)];
        componentStr = [componentStr stringByAppendingFormat:@"superview的背景颜色 : %@ \n",view.superview.backgroundColor];
        componentStr = [componentStr stringByAppendingFormat:@"superview的描述信息 : %@ \n",[view.superview description]];
    }
    /**********************/
    
    /*
     * 获取view的subView信息
     */
    /**********************/
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------子view的布局信息------------- \n"];
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView* subView in view.subviews) {
            if ([subView isKindOfClass:[KSDebugPropertyButton class]]) {
                continue;
            }
            NSUInteger index = [view.subviews indexOfObject:subView];
            componentStr = [componentStr stringByAppendingFormat:@"%lu、 \n", index];
            componentStr = [componentStr stringByAppendingFormat:@"subViewClass : %@ \n",NSStringFromClass([subView class])];
            componentStr = [componentStr stringByAppendingFormat:@"subView的位置宽高 : %@ \n",NSStringFromCGRect(subView.frame)];
            componentStr = [componentStr stringByAppendingFormat:@"subView的背景颜色 : %@ \n",subView.backgroundColor];
            componentStr = [componentStr stringByAppendingFormat:@"subView的描述信息 : %@ \n",[subView description]];
        }
    }
    /**********************/
    
    /*
     * 获取view变量属性值
     */
    /**********************/
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------view的变量属性值------------- \n"];
    NSMutableDictionary* viewPropertyDict = [KSDebugUtils getInstansePropertyWithInstanse:view];
    NSMutableDictionary* viewPropertyTranslateDict = [[NSMutableDictionary alloc] initWithCapacity:[viewPropertyDict count]];
    [viewPropertyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [viewPropertyTranslateDict setObject:obj forKey:key];
        }else if([obj respondsToSelector:@selector(description)]){
            [viewPropertyTranslateDict setObject:[obj description] forKey:key];
        }
    }];
    NSString* componentItemStr = [self generateStringWithDictionary:viewPropertyTranslateDict];
    
    if (componentItemStr) {
        componentStr = [componentStr stringByAppendingFormat:@"变量属性值:\n%@ \n",componentItemStr];
    }
    /**********************/
    
    return componentStr;
}

-(void)showComponentViewWithAnimation:(UIView*)view{
    // 回到页面顶部
    [self setContentOffset:CGPointZero];
    CGRect visibleViewRect = [view convertRect:view.bounds toView:self.debugViewReference];
    // 去掉线框后截图用于顶部展示
    [self recurSetBackgroundColorWithView:view isRandom:NO];
    self.selectViewTranslateToImageView.image = view.screenshot;
    [self recurSetBackgroundColorWithView:view isRandom:YES];
    self.selectViewTranslateToImageView.frame = visibleViewRect;
    [self bringSubviewToFront:self.selectViewTranslateToImageView];
    // 展示取消按钮的背景
    [self __getCancelButton].hidden = NO;
    // 展示动画效果
    [UIView animateKeyframesWithDuration:0.8 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        // 修正截图位置
        CGRect rect = view.bounds;
        if (view.frame.size.width < self.infoLabel.frame.size.width) {
            rect.origin.x = (self.frame.size.width - view.frame.size.width)/2;
        }else{
            rect.origin.x = CGRectGetMinX(self.infoLabel.frame);
            rect.size.width = CGRectGetWidth(self.infoLabel.frame);
            rect.size.height = rect.size.width / view.frame.size.width * view.frame.size.height;
        }
        rect.origin.y = CGRectGetMaxY(self.infoLabel.frame) + 10;
        [self.selectViewTranslateToImageView setFrame:rect];
        
        // 修正scriptDebutTextView脚本输入框位置
        rect = self.scriptDebutTextView.frame;
        rect.origin.y = CGRectGetMaxY(self.selectViewTranslateToImageView.frame) + 10;
        [self.scriptDebutTextView setFrame:rect];
        
        // 修正scriptOperationShowTextView脚本响应框位置
        rect = self.scriptOperationShowTextView.frame;
        rect.origin.y = CGRectGetMaxY(self.scriptDebutTextView.frame) + 10;
        [self.scriptOperationShowTextView setFrame:rect];
        
        // 修正文本textView位置
        rect = self.debugTextViewFrame;
        rect.origin.y = CGRectGetMaxY(self.scriptOperationShowTextView.frame) + 10;
        rect.size.height = [self.debugTextView.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(rect), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.debugTextView.font,NSFontAttributeName, nil] context:nil].size.height + 5 * self.debugTextView.font.pointSize + 10;
        if (rect.size.height > 8000) {
            rect.size.height = 8000;
        }
        [self.debugTextView setFrame:rect];
        self.debugTextViewFrame = rect;
        
        // 修正closeButton关闭按钮位置
        rect = self.closeButton.frame;
        rect.origin.y = CGRectGetMaxY(self.debugTextView.frame) + 10;
        [self.closeButton setFrame:rect];
        
        // 修正当前view的展示区域
        self.contentSize = CGSizeMake(self.contentSize.width, CGRectGetMaxY(self.closeButton.frame) + 10);
        
        // 修正cancelButton的展示区域
        rect = [self __getCancelButton].frame;
        rect.size.height = self.contentSize.height;
        [[self __getCancelButton] setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   wax script method

-(id)getWaxScriptWithView:(UIView*)selectView{
    return nil;
}

-(NSString*)getWaxScriptWithScriptText:(NSString*)scriptText{
    if (scriptText == nil || scriptText.length == 0) {
        return nil;
    }
    NSMutableString* waxScript = [NSMutableString string];
    [waxScript appendString:@"waxClass{\"KSDebugLayoutInfoView\"}\n"];
    [waxScript appendString:@"function getWaxScriptWithView(self, sv)\n"];
    [waxScript appendString:[NSString stringWithFormat:@"%@\n",scriptText]];
    [waxScript appendString:@"end"];
    
    return waxScript;
}

-(void)runLuaStringWithScriptText:(NSString*)scriptText withSelectView:(UIView*)selectView{
    if (selectView == nil) {
        return;
    }
    if (scriptText == nil || scriptText.length == 0) {
        return;
    }
    NSString* waxScript = [self getWaxScriptWithScriptText:scriptText];
    if (waxScript) {
        @try {
            NSInteger i = wax_runLuaString([waxScript UTF8String]);
            if (i != 0) {
                [self.scriptOperationShowTextView setText:[NSString stringWithFormat:@"error=%s", lua_tostring(wax_currentLuaState(), -1) ]];
                NSLog(@"error=%s",lua_tostring(wax_currentLuaState(), -1));
            }else{
                [self.scriptOperationShowTextView setText:@"执行成功"];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"----> crash because of %@", exception.reason);
        }
    }
    id scriptValue = [self getWaxScriptWithView:selectView];
    if (scriptValue) {
        [self.scriptOperationShowTextView setText:[scriptValue description]];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   override method
-(void)startDebug{
    [super startDebug];
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    @try {
        [self recurSetBackgroundColorWithView:view isRandom:YES];
    }
    @catch (NSException *exception) {
        [KSDebugToastView toast:[NSString stringWithFormat:@"startDebug crash because of %@",exception.reason] toView:self.debugViewReference displaytime:3];
    }
    
    self.hidden = YES;
    [self removeFromSuperview];
    
    if (![KSDebugUserDefault getUserHadClicedLayoutInfoBtn]) {
        [KSDebugToastView toast:@"温馨提示：点击彩色框内区域试试！\n再点击“布局信息”可取消查看哦！^_^" toView:self.debugViewReference displaytime:5];
        [KSDebugUserDefault setUserHadClicedLayoutInfoBtn:YES];
    }
}

-(void)endDebug{
    [super endDebug];
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    @try {
        [self recurSetBackgroundColorWithView:view isRandom:NO];
        [self recurRemovePropertyButtonWithView:view];
    }
    @catch (NSException *exception) {
        [KSDebugToastView toast:[NSString stringWithFormat:@"endDebug crash because of %@",exception.reason] toView:self.debugViewReference displaytime:3];
    }
}

-(void)keyboardDidShowWithTextView:(UITextView*)debugTextView{
    [self setScrollEnabled:NO];
}

-(void)keyboardDidHideWithTextView:(UITextView*)debugTextView{
    [self setScrollEnabled:YES];
}

-(void)closeButtonClick:(id)sender{
    [self showCurrentView:NO];
}

-(void)canceBackgroundlAction{
    if (self.needCancelBackgroundAction) {
        [self __getCancelButton].hidden = YES;
    }
    [self showCurrentView:NO];
}

-(void)showCurrentView:(BOOL)isShow{
    if (isShow) {
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        [self.debugViewReference addSubview:self];
    }else{
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        [self removeFromSuperview];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if (self.viewArray != nil
        && buttonIndex >= 1
        && buttonIndex - 1 < [self.viewArray count]) {
        UIView* view = [self.viewArray objectAtIndex:buttonIndex - 1];
        NSString* componentStr = [self getComponentViewInfoWithView:view];
        self.debugTextView.text = componentStr;
        [self showComponentViewWithAnimation:view];
        [self showCurrentView:YES];
    }
}

@end
