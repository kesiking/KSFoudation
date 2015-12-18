//
//  WeAppDebug3DInspectorView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-9.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebug3DInspectorView.h"
#import "KSDebugOperationView.h"
#import "ServiceInspector_Window.h"
#import "UIView+Screenshot.h"

@interface KSDebug3DInspectorView(){
    BOOL	_inspecting;
}

@property(nonatomic, strong)  ServiceInspector_Window*   inspectior3DWindow;

@end

@implementation KSDebug3DInspectorView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3D渲染效果",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)setupView{
    [super setupView];
    self.needCancelBackgroundAction = NO;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

-(ServiceInspector_Window *)inspectior3DWindow{
    if (_inspectior3DWindow == nil) {
        _inspectior3DWindow = [[ServiceInspector_Window alloc] initWithFrame:self.bounds];
        [self addSubview:_inspectior3DWindow];
        [self.closeButton setFrame:CGRectMake(self.frame.size.width - 110, CGRectGetMaxY(self.frame) - 50, 100, 40)];
        [self bringSubviewToFront:self.closeButton];
    }
    return _inspectior3DWindow;
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    self.closeButton.hidden = NO;
    [self show3DInspectiorView];
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
    [self hide3DInspectiorView];
}

-(void)closeButtonDidSelect{

}

-(void)show3DInspectiorView{
    [self.inspectior3DWindow prepareShowWithView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
    
    [UIView beginAnimations:@"OPEN" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didOpen)];
    
    [self.inspectior3DWindow show];
    
    [UIView commitAnimations];
}

-(void)hide3DInspectiorView
{
    [UIView beginAnimations:@"CLOSE" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didClose)];
    
    
    [self.inspectior3DWindow prepareHide];
    
    [UIView commitAnimations];
}

#pragma mark -

- (void)didOpen
{
    _inspecting = YES;
}

- (void)didClose
{
    [self.inspectior3DWindow hide];
    
    _inspecting = NO;
}

@end
