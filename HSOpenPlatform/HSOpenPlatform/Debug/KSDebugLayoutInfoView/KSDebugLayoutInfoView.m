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

#define KSDEBUG_PROPERTY_BUTTON_TAG  (11002)

@interface KSDebugLayoutInfoView()

@property(nonatomic, strong)  UIImageView           *   selectViewTranslateToImageView;

@end

@implementation KSDebugLayoutInfoView

#ifdef KSDebugToolsEnable
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"布局信息",@"title",NSStringFromClass([self class]),@"className", nil]];
}
#endif

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

-(void)recurSetBackgroundColorWithView:(UIView*)view isRandom:(BOOL)random{
    if (view == nil
        || [view isKindOfClass:[KSDebugPropertyButton class]]
        || [view isKindOfClass:NSClassFromString(@"MAMapView")]
        || [NSStringFromClass([view class]) hasPrefix:@"KSDebug"]) {
        return;
    }

    KSDebugPropertyButton *propertyButton = (KSDebugPropertyButton*)[view viewWithTag:KSDEBUG_PROPERTY_BUTTON_TAG];
    if (propertyButton == nil) {
        propertyButton = [[KSDebugPropertyButton alloc] initWithFrame:view.bounds];
        [propertyButton setBackgroundColor:[UIColor clearColor]];
        propertyButton.exclusiveTouch = YES;
        propertyButton.tag = KSDEBUG_PROPERTY_BUTTON_TAG;
        [propertyButton addTarget:self action:@selector(checkComponentInfo:) forControlEvents:UIControlEventTouchUpInside];
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

-(NSString*)getComponentViewInfoWithView:(UIView*)view{
    NSString* componentStr = [NSString string];
    componentStr = [componentStr stringByAppendingFormat:@"-----------布局信息------------- \n"];
    /*
     * 获取viewController的基本信息
     */
    /**********************/
    UIViewController* currentViewController = [KSDebugUtils getCurrentAppearedViewController];
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------viewController的布局信息------------- \n"];
    componentStr = [componentStr stringByAppendingFormat:@"描述信息 : %@ \n",[currentViewController description]];
    /**********************/

    /*
     * 获取view的基本信息
     */
    /**********************/
    componentStr = [componentStr stringByAppendingFormat:@"\n-----------view的布局信息------------- \n"];
    componentStr = [componentStr stringByAppendingFormat:@"viewClass : %@ \n",NSStringFromClass([view class])];
    componentStr = [componentStr stringByAppendingFormat:@"位置宽高 : %@ \n",NSStringFromCGRect(view.frame)];
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
        
        // 修正文本textView位置
        rect = self.debugTextViewFrame;
        rect.origin.y = CGRectGetMaxY(self.selectViewTranslateToImageView.frame) + 10;
        rect.size.height = [self.debugTextView.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(rect), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.debugTextView.font,NSFontAttributeName, nil] context:nil].size.height + 5 * self.debugTextView.font.pointSize;
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

-(void)startDebug{
    [super startDebug];
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    [self recurSetBackgroundColorWithView:view isRandom:YES];
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
    [self recurSetBackgroundColorWithView:view isRandom:NO];
    [self recurRemovePropertyButtonWithView:view];
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

@end
