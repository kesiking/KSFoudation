//
//  EHLoadingToast.m
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHLoadingToast.h"
#import "MBProgressHUD.h"

@interface EHLoadingToast()

@property (nonatomic, strong)UIView *superView;

@end

@implementation EHLoadingToast

+(EHLoadingToast *)sharedManager{
    static dispatch_once_t predicate;
    static EHLoadingToast * sharedManager;
    dispatch_once(&predicate, ^{
        sharedManager=[[EHLoadingToast alloc] init];
    });
    return sharedManager;
}

+ (void)toast{
    [EHLoadingToast toastWithText:nil];
}

+ (void)toastWithText:(NSString *)text{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [EHLoadingToast toastWithText:text InView:window];
}

+ (void)toastWithText:(NSString *)text InView:(UIView *)view{
    [EHLoadingToast sharedManager].superView = view;
    
    EHCircleView *loadingView = [[EHCircleView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [loadingView show];
    
    MBProgressHUD *mbHud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:mbHud];
    mbHud.mode = MBProgressHUDModeCustomView;
//    mbHud.minShowTime = 0.5;
    mbHud.customView = loadingView;
    mbHud.labelText = text;
//    mbHud.userInteractionEnabled = NO;
    [mbHud show:YES];
}

+ (void)finishToast:(NSString *)text{
    UIView *view = [EHLoadingToast sharedManager].superView;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    hud.customView = nil;
    hud.labelText = text;
    [self hide:YES afterDelay:1];
}

+ (void)hide{
    [self hide:YES];
}

+ (void)hide:(BOOL)animated{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:window animated:animated];
}

+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}


+ (void)hideDelayed:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

@end



#define kWidth  CGRectGetWidth(self.frame)
#define kHeight CGRectGetHeight(self.frame)
#define kMinScale 0.2
#define sinAngle(a) sin(a / 180.0 * M_PI)
#define cosAngle(a) cos(a / 180.0 * M_PI)

@implementation EHCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleColor = [UIColor whiteColor];
    }
    return self;
}

- (void)show{
    [self addCircleLayers];
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
}

- (void)addCircleLayers{
    CGFloat length = MIN(kWidth, kHeight);
    CGPoint center = CGPointMake(length / 2.0, length / 2.0);
    
    for (int i = 0; i < 8; i++) {
        CGPoint point = CGPointMake(center.x + length / 2.0 * 3 / 4 * sinAngle(45 *i), center.y + length / 2.0 * 3 / 4 * sinAngle(((45 * i) - 90)));
        UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:point radius:length / 8.0 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.anchorPoint = CGPointMake(point.x / length, point.y / length);
        layer.frame = self.bounds;
        layer.path = bp.CGPath;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.fillColor = self.circleColor.CGColor;
        [layer addAnimation:[self scaleAnimation:i] forKey:@"scaleAnimation"];
        
        [self.layer addSublayer:layer];
    }
}

- (CAAnimation *)scaleAnimation:(int)tag{
    CABasicAnimation *scaleAnm = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnm.fromValue = @1;
    scaleAnm.toValue = @kMinScale;
    scaleAnm.duration = 1;
    scaleAnm.autoreverses = YES;
    scaleAnm.timeOffset = (1 - (tag + 7) % 8 / 7.0)/0.6;
    scaleAnm.repeatCount = INFINITY;
    return scaleAnm;
}

- (CAAnimation *)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = @(M_PI*2);
    rotationAnimation.duration= 8;
    rotationAnimation.repeatCount = INFINITY;
    return rotationAnimation;
}

@end
