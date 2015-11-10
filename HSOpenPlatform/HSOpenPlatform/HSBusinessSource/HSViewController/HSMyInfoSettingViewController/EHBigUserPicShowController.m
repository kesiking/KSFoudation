//
//  EHBigUserPicShowController.m
//  eHome
//
//  Created by xtq on 15/6/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBigUserPicShowController.h"

#define SCROLLDISTANCE  120.0

@implementation EHBigUserPicShowController
{
    UIView *_shadowView;
    UIImageView *_bigUserPicView;
    CGRect _fromViewRect;       //原视图位置
    CGRect _finalRect;          //大视图位置
    CGPoint _fromCenter;        //原视图中心
    CGPoint _finalCenter;       //大视图中心
}

#pragma mark - Life Circle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _fromViewRect = [self.fromView.superview convertRect:self.fromView.frame toView:nil];
    CGFloat width = CGRectGetWidth(self.view.frame) - kSpaceX * 6;
    _finalRect = CGRectMake(kSpaceX * 3, (CGRectGetHeight(self.view.frame) - width) / 2.0, width, width);
    _fromCenter = CGPointMake(_fromViewRect.origin.x + _fromViewRect.size.width / 2.0, _fromViewRect.origin.y + _fromViewRect.size.width / 2.0);
    _finalCenter = self.view.center;
    
    _fromView.hidden = YES;
    [self.view addSubview:[self bgView]];
    [self.view addSubview:[self bigUserPicView]];
}

- (void)viewWillAppear:(BOOL)animate{
    [super viewWillAppear:animate];
    
    //先缩小再动画回正
    CGFloat scale = _fromViewRect.size.width/ _finalRect.size.width;
    _bigUserPicView.layer.transform = CATransform3DMakeScale(scale, scale, 1);
    _bigUserPicView.center = _fromCenter;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        _bigUserPicView.layer.transform = CATransform3DIdentity;
        _bigUserPicView.center = _finalCenter;
    } completion:^(BOOL finished) {
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fromView.hidden = NO;
}

#pragma mark - Events Response
- (void)shadowViewTap:(UITapGestureRecognizer *)tap{
    //动画缩小到原视图位置
    typeof(self) __weak weakSelf = self;
    CGFloat scale = _fromViewRect.size.width/ _finalRect.size.width;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0];
        _bigUserPicView.layer.transform = CATransform3DMakeScale(scale, scale, 1);
        _bigUserPicView.center = _fromCenter;
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{}];

    }];
}

//大视图平移动画
-(void)bigUserPicViewPan:(UIPanGestureRecognizer *)pan{
    static CGPoint initialPoint;
    CGFloat factorOfAngle = 0.0f;
    CGFloat factorOfScale = 0.0f;
    CGPoint transition = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        initialPoint = _bigUserPicView.center;
        
    }
    else if(pan.state == UIGestureRecognizerStateChanged){
        
        _bigUserPicView.center = CGPointMake(initialPoint.x,initialPoint.y + transition.y);
        CGFloat Y =MIN(SCROLLDISTANCE,MAX(0,ABS(transition.y)));
        
        //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factorOfAngle*(M_PI/5), transition.y>0?-1:1, 0, 0);
        t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0);
        
        //如果不设置，它的一部分传递到负 z 空间，所以是背后的背景。
        _bigUserPicView.layer.zPosition = 400;  // or some number greater than width/2
        
        _bigUserPicView.layer.transform = t;
    }
    else if ((pan.state == UIGestureRecognizerStateEnded) || (pan.state ==UIGestureRecognizerStateCancelled)){

        if (ABS(transition.y) > 100) {
            [self shadowViewTap:nil];
        }
        else{
            [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _bigUserPicView.layer.transform = CATransform3DIdentity;
                _bigUserPicView.center = initialPoint;
            } completion:nil];

        }
    }
}

#pragma mark - Helper Functions
/**
 *  全屏截图
 */
- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Getters And Setters
- (UIImageView *)bgView{
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[self screenshot]];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgImageView.userInteractionEnabled = YES;
    [bgImageView addSubview:[self shadowView]];
    return bgImageView;
}

- (UIView *)shadowView{
    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _shadowView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0];
    _shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowViewTap:)];
    [_shadowView addGestureRecognizer:tap];
    return _shadowView;
}

- (UIImageView *)bigUserPicView{
    if (!_bigUserPicView) {
        _bigUserPicView = [[UIImageView alloc]initWithImage:self.fromView.image];
        _bigUserPicView.frame = _finalRect;
        _bigUserPicView.layer.masksToBounds = YES;
        CGFloat x = self.fromView.layer.cornerRadius / self.fromView.frame.size.width;
        _bigUserPicView.layer.cornerRadius = CGRectGetWidth(_bigUserPicView.frame) * x;
        UIPanGestureRecognizer *bigUserPicViewPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bigUserPicViewPan:)];
        [self.view addGestureRecognizer:bigUserPicViewPan];
    }
    return _bigUserPicView;
}

@end
