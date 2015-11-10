//
//  TBLoadingView.m
//  Taobao2013
//
//  Created by 香象 on 1/31/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import "WeAppLoadingView.h"

@interface WeAppLoadingView()

@end

@implementation WeAppLoadingView

-(void)startAnimating{
    if (self.loadingViewType == WeAppLoadingViewTypeDefault) {
        [super startAnimating];
        return;
    }
    [self.loadingView startAnimating];
}

-(void)stopAnimating{
    if (self.loadingViewType == WeAppLoadingViewTypeDefault) {
        [super stopAnimating];
        return;
    }
    
    [self.loadingView stopAnimating];
}

-(KSCircleView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[KSCircleView alloc] initWithFrame:self.bounds];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.1f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    NSArray* imagesArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"loading_view_1.png"],
                            [UIImage imageNamed:@"loading_view_2.png"],
                            [UIImage imageNamed:@"loading_view_3.png"],
                            [UIImage imageNamed:@"loading_view_4.png"],
                            [UIImage imageNamed:@"loading_view_5.png"],
                            [UIImage imageNamed:@"loading_view_6.png"],
                            [UIImage imageNamed:@"loading_view_7.png"],
                            [UIImage imageNamed:@"loading_view_8.png"],
                            nil];
    self.animationImages = imagesArray;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 0;
    
}

@end

#define kWidth  CGRectGetWidth(self.frame)
#define kHeight CGRectGetHeight(self.frame)
#define kMinScale 0.2
#define sinAngle(a) sin(a / 180.0 * M_PI)
#define cosAngle(a) cos(a / 180.0 * M_PI)

@implementation KSCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    [self resetCircleLayers];
}

- (void)resetCircleLayers{
    for (CALayer* layer in self.layer.sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    [self addCircleLayers];
}

- (void)startAnimating{
    [self.layer removeAllAnimations];
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
}

- (void)stopAnimating{
    [self.layer removeAllAnimations];
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
        layer.fillColor = self.circleColor?self.circleColor.CGColor:[UIColor whiteColor].CGColor;
        [layer addAnimation:[self scaleAnimation:i] forKey:@"scaleAnimation"];
        
        [self.layer addSublayer:layer];
    }
}

- (CAAnimation *)scaleAnimation:(int)tag{
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation *scaleAnm = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnm.fromValue = @1;
    scaleAnm.toValue = @kMinScale;
    scaleAnm.duration = 1;
    scaleAnm.timeOffset = (1 - (tag + 7) % 8 / 7.0)/0.6;
    scaleAnm.repeatCount = INFINITY;
    scaleAnm.timingFunction = linearCurve;
    scaleAnm.removedOnCompletion = NO;
    scaleAnm.autoreverses = YES;
    return scaleAnm;
}

- (CAAnimation *)rotationAnimation{
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = @(M_PI*2);
    rotationAnimation.duration = 8;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.timingFunction = linearCurve;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.autoreverses = NO;
    return rotationAnimation;
}

@end
