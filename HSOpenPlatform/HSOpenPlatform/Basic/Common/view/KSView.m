//
//  KSView.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-17.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSModelStatusBasicInfo.h"

@interface KSView()

@property(nonatomic,assign) BOOL                isFirstSetupView;

@end

@implementation KSView

+ (UIView *)findKeyboard {
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view {
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            if ([subView.superview isKindOfClass:NSClassFromString(@"_UIKBCompatInputView")]) {
                return subView.superview;
            }
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!self.isFirstSetupView) {
            [self setupView];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.isFirstSetupView) {
            [self setupView];
        }    }
    return self;
}

-(void)awakeFromNib{
    if (!self.isFirstSetupView) {
        [self setupView];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ([self needTouchEventLog]) {
        [KSTouchEvent touchWithView:self];
    }
}

-(void)setFrame:(CGRect)frame{
    if (self.viewFrameWillChangedBlock) {
        self.viewFrameWillChangedBlock(self, frame , self.frame);
    }
    CGRect oldFrame = self.frame;
    [super setFrame:frame];
    if (self.viewFrameDidChangedBlock) {
        self.viewFrameWillChangedBlock(self, self.frame , oldFrame);
    }
}

#pragma mark- override by subclass

-(void)setupView{
    self.isFirstSetupView = YES;
}

-(void)refreshDataRequest{
    
}

-(BOOL)needTouchEventLog{
    return YES;
}

#pragma mark- TBModelStatusHandler

- (TBModelStatusHandler*)statusHandler{
    if (_statusHandler == nil) {
        KSModelStatusBasicInfo *info = [[KSModelStatusBasicInfo alloc] init];
        
        info.titleForErrorBlock=^(NSError*error){
            return @"服务器正忙，请稍微再试";
        };
        info.subTitleForErrorBlock=^(NSError*error){
            return error.userInfo[NSLocalizedDescriptionKey];
        };
        info.actionButtonTitleForErrorBlock=^(NSError*error){
            return @"立刻刷新";
        };
        
        WEAKSELF
        _statusHandler = [[TBModelStatusHandler alloc] initWithStatusInfo:info];
        _statusHandler.selectorForErrorBlock=^(NSError *error){
            STRONGSELF
            [strongSelf refreshDataRequest];
        };
    }
    return _statusHandler;
}

#pragma mark- used by subclass

-(void)showLoadingView{
    [self.statusHandler showLoadingViewInView:self];
}

-(void)hideLoadingView{
    [self.statusHandler hideLoadingView];
}

-(void)showErrorView:(NSError*)error{
    [self.statusHandler showViewforError:error inView:self frame:self.bounds];
}

-(void)hideErrorView{
    [self.statusHandler removeStatusViewFromView:self];
}

-(void)showEmptyView{
    [self.statusHandler showEmptyViewInView:self frame:self.frame];
}

-(void)hideEmptyView{
    [self.statusHandler removeStatusViewFromView:self];
}

@end
