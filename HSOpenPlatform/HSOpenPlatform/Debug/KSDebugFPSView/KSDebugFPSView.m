//
//  KSDebugFPSView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugFPSView.h"
#import "KSDebugFPSLabel.h"
#import "KSDebugOperationView.h"


@interface KSDebugFPSView ()

@property (strong,nonatomic) KSDebugFPSLabel *FPSLabel;

@end

@implementation KSDebugFPSView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"帧率",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)setupView{
    [super setupView];
    self.needCancelBackgroundAction = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    [self.FPSLabel setHidden:NO];
    
//    if (![KSDebugUserDefault getUserHadClicedMemoryBtn]) {
//        [KSDebugToastView toast:@"再点击“内存信息”可取消查看哦！^_^" toView:self.debugViewReference displaytime:5];
//        [KSDebugUserDefault setUserHadClicedMemoryBtn:YES];
//    }
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
}

-(KSDebugFPSLabel *)FPSLabel{
    if (!_FPSLabel) {
        _FPSLabel = [[KSDebugFPSLabel alloc]initWithFrame:CGRectMake(0, 100, 105, 30)];
        //_FPSLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_FPSLabel];
    }
    return _FPSLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
