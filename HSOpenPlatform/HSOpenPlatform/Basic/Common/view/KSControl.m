//
//  KSControl.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSControl.h"
#import "KSModelStatusBasicInfo.h"

@interface KSControl()

@property(nonatomic,assign) BOOL                isFirstSetupView;

@end

@implementation KSControl

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

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if ([self needTouchEventLog]) {
        [KSTouchEvent touchWithView:self];
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
