//
//  TQLoadingView.m
//  TQLoadingView
//
//  Created by xtq on 15/4/22.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "TQLoadingView.h"
#define sinAngle(a) sin(a / 180.0 * M_PI)
#define cosAngle(a) cos(a / 180.0 * M_PI)
@implementation TQLoadingView
{
    
    CGFloat _circlePercentage;      //圆形周长占总长度的比例
    CGFloat _leftPercentage;        //对勾左线长占总长度的比例
    CGFloat _rightPercentage;       //对勾右线长占总长度的比例
    CGFloat _leftSpringPercentage;  //对勾左线长弹性时占总长度的比例
    CGFloat _rightSpringPercentage; //对勾右线长弹性时占总长度的比例

    CAShapeLayer *_successLayer;    //圆形到对勾的整个显示图层
    CAShapeLayer *_errorLayer1;     //左上到右下直线
    CAShapeLayer *_errorLayer2;     //右上到左下直线

    BOOL _isFinished;               //是否完成并进行动画
    FinishBlock _finishBlock;       //动画结束回调
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isFinished = NO;

        //等待旋转圆形属性设置
        self.lineCount = 2;     //默认2
        self.lineWidth = 5;     //默认5
        self.subCount = 240;    //默认240
        self.lineColor = [UIColor whiteColor];//默认白
        self.duration = 1;      //默认1秒
    }
    return self;
}

//画圆
-(void)drawRect:(CGRect)rect{
    NSLog(@"drawRect !_isFinished = %d",!_isFinished);
   
    if (!_isFinished) {
        [self removeLayers];
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0-self.lineWidth/2.0;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        for (int i = 0; i < self.subCount; i++) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddArc(path, NULL, self.bounds.size.width/2.0, self.bounds.size.height/2.0, radius, i*M_PI*2/self.subCount, (i+1)*M_PI*2/self.subCount, 0);
            CGContextAddPath(ctx, path);
            
            CGContextSetLineWidth(ctx, self.lineWidth);
            int num = self.subCount/self.lineCount;
            
            if (i%num == 0) CGContextSetLineCap(ctx, kCGLineCapRound);
            else CGContextSetLineCap(ctx, kCGLineCapButt);
            CGContextSetAlpha(ctx, (1-((CGFloat)(i%num)/num)));
            CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
            
            CGContextDrawPath(ctx, kCGPathStroke);
            CGPathRelease(path);
        }
    }
    _isFinished = YES;
}

//显隐并旋转动画
-(void)show{

    [self setNeedsDisplay];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = 0.7;
    opacityAnimation.repeatCount = 1;
    [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = @(-M_PI*2);
    rotationAnimation.duration= self.duration;
    rotationAnimation.repeatCount = INFINITY;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityAnimation,rotationAnimation];
    group.duration = self.duration;
    group.repeatCount = INFINITY;
    
    [self.layer addAnimation:rotationAnimation forKey:@"circleGroup"];
}

//成功动画
-(void)success:(FinishBlock)finishBlock{
    _isFinished = YES;
    [self.layer removeAllAnimations];
    [self setNeedsDisplay];
    [self addSuccessLayer];
    _finishBlock = finishBlock;
}

//错误动画
-(void)error:(FinishBlock)finishBlock{
    _isFinished = YES;
    [self.layer removeAllAnimations];
    [self setNeedsDisplay];
    [self addErrorLayer];
    _finishBlock = finishBlock;
}

-(void)hide{
    _isFinished = NO;
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//对勾图层
-(void)addSuccessLayer{
    CGRect frame = self.frame;
    //圆形到对勾设置。半径。
    CGFloat radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0-self.lineWidth/2.0;
    CGFloat _lCircle = radius*M_PI*2;   //圆形的周长
    CGFloat _lLeft = radius * 1.1;      //对勾左线段长度
    CGFloat _lRight = radius * 1.4;     //对勾右线段长度
    CGFloat angle = 40;
    //圆心、对勾左上角顶点、对勾中间顶点、对勾右上角顶点
    CGPoint pointCenter = CGPointMake(MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0, MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0);
    CGPoint pointLeft = CGPointMake(pointCenter.x - radius*cosAngle(30), pointCenter.y - radius * sinAngle(30));
    CGPoint pointMid = CGPointMake(pointLeft.x + _lLeft * sinAngle(angle), pointLeft.y + _lLeft * cosAngle(angle));
    CGPoint pointRight = CGPointMake(pointMid.x + _lRight * cosAngle(angle), pointMid.y -_lRight * sinAngle(angle));
    
    CGFloat lTotal = _lCircle + _lLeft + _lRight;
    _circlePercentage = _lCircle / lTotal;
    _leftPercentage = (0.4 * _lLeft + _lCircle) / lTotal;
    _rightPercentage = (lTotal - _lRight * 0.2) / lTotal;
    _leftSpringPercentage = (0.6 * _lLeft + _lCircle) / lTotal;
    _rightSpringPercentage = (lTotal - _lRight * 0.03) / lTotal;
    
    //圆形到对勾路径
    UIBezierPath *bp = [UIBezierPath bezierPath];
    [bp addArcWithCenter:pointCenter radius:radius startAngle:-M_PI/6*5 endAngle:(-M_PI/6*5-2*M_PI) clockwise:NO];
    [bp addLineToPoint:pointMid];
    [bp addLineToPoint:pointRight];
    
    [self removeLayers];
    _successLayer = [CAShapeLayer layer];
    _successLayer.path = bp.CGPath;
    _successLayer.lineWidth = self.lineWidth;
    _successLayer.strokeColor = self.lineColor.CGColor;
    _successLayer.fillColor = [UIColor clearColor].CGColor;
    _successLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _successLayer.strokeStart = 0;
    _successLayer.strokeEnd = _circlePercentage;
    [_successLayer addAnimation:[self animationFinished] forKey:@"successAnimation"];
    [self.layer addSublayer:_successLayer];
}

//错误图层
- (void)addErrorLayer{
    CGRect frame = self.frame;
    //半径。
    CGFloat radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0-self.lineWidth/2.0;
    
    //圆心、sin45
    CGPoint pointCenter = CGPointMake(MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0, MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 2.0);
    CGFloat s = sinAngle(45);
    
    CGPoint p1 = CGPointMake(pointCenter.x - radius * s, pointCenter.y - radius * s);   //左上
    CGPoint p2 = CGPointMake(pointCenter.x + radius * s, pointCenter.y - radius * s);   //右上
    CGPoint p3 = CGPointMake(pointCenter.x - radius * s, pointCenter.y + radius * s);   //左下
    CGPoint p4 = CGPointMake(pointCenter.x + radius * s, pointCenter.y + radius * s);   //右下
    
    UIBezierPath *bp1 = [UIBezierPath bezierPath];
    [bp1 moveToPoint:p1];
    [bp1 addLineToPoint:p4];
    
    UIBezierPath *bp2 = [UIBezierPath bezierPath];
    [bp2 moveToPoint:p2];
    [bp2 addLineToPoint:p3];
    
    [self removeLayers];
    _errorLayer1 = [CAShapeLayer layer];
    _errorLayer1.path = bp1.CGPath;
    _errorLayer1.lineWidth = self.lineWidth;
    _errorLayer1.strokeColor = self.lineColor.CGColor;
    _errorLayer1.fillColor = [UIColor clearColor].CGColor;
    _errorLayer1.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _errorLayer1.strokeStart = 0.1;
    _errorLayer1.strokeEnd = 0.9;
    [_errorLayer1 addAnimation:[self animationError] forKey:@"errorAnimation1"];
    [self.layer addSublayer:_errorLayer1];
    
    _errorLayer2 = [CAShapeLayer layer];
    _errorLayer2.path = bp2.CGPath;
    _errorLayer2.lineWidth = self.lineWidth;
    _errorLayer2.strokeColor = self.lineColor.CGColor;
    _errorLayer2.fillColor = [UIColor clearColor].CGColor;
    _errorLayer2.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _errorLayer2.strokeStart = 0.1;
    _errorLayer2.strokeEnd = 0.9;
    [_errorLayer2 addAnimation:[self animationError] forKey:@"errorAnimation2"];
    [self.layer addSublayer:_errorLayer2];
}

//圆形到对勾动画
-(CAAnimation *)animationFinished{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.values = @[@0,@(_leftPercentage),@(_leftSpringPercentage),@(_leftPercentage)];
    strokeStartAnimation.keyTimes = @[@0,@0.7,@0.85,@1];
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.beginTime = 0.2;
    strokeStartAnimation.duration = 0.4;
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.removedOnCompletion = NO;
    
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.values = @[@(_circlePercentage),@(_rightPercentage),@(_rightSpringPercentage),@(_rightPercentage)];
    strokeEndAnimation.keyTimes = @[@0,@0.7,@0.85,@1];
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.beginTime = 0.2;
    strokeEndAnimation.duration = 0.4;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityAnimation,strokeStartAnimation,strokeEndAnimation];
    group.duration = 1;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate =self;
    return group;
}

//X动画
- (CAAnimation *)animationError{
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.values = @[@0,@0.1,@0.2,@0.1];
    strokeStartAnimation.keyTimes = @[@0,@0.5,@0.75,@1];
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.duration = 0.3;
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.removedOnCompletion = NO;
    
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.values = @[@0,@0.9,@0.95,@0.9];
    strokeEndAnimation.keyTimes = @[@0,@0.5,@0.75,@1];
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.duration = 0.3;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[strokeStartAnimation,strokeEndAnimation];
    group.duration = 1;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate =self;
    return group;
}

- (void)removeLayers{
    if (_successLayer) {
        [_successLayer removeFromSuperlayer];
        _successLayer = nil;
    }
    if (_errorLayer1) {
        [_errorLayer1 removeFromSuperlayer];
        _errorLayer1 = nil;
    }
    if (_errorLayer2) {
        [_errorLayer2 removeFromSuperlayer];
        _errorLayer2 = nil;
    }
}

//动画结束回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([_successLayer animationForKey:@"successAnimation"]==anim){
        !_finishBlock?:_finishBlock();
        _finishBlock = nil;
    }

    if ([_errorLayer1 animationForKey:@"errorAnimation1"]==anim){
        !_finishBlock?:_finishBlock();
        _finishBlock = nil;
    }
    _isFinished = NO;
    //[self hide];
}

@end
