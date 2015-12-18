//
//  HSCButton.m
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KSDebugPropertyButton.h"
#import "KSDebugToastView.h"

@interface KSDebugPropertyButton()

@property (nonatomic, assign) BOOL             buttonHasMoved;

@end

@implementation KSDebugPropertyButton

@synthesize dragEnable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor redColor];
        self.buttonHasMoved = NO;
    }
    return self;
}

-(NSMutableDictionary *)dictObject{
    if (_dictObject == nil) {
        _dictObject = [[NSMutableDictionary alloc] init];
    }
    return _dictObject;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.buttonHasMoved = NO;
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!dragEnable) {
        return;
    }
    self.buttonHasMoved = YES;
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.buttonHasMoved) {
        [super touchesEnded:touches withEvent:event];
    }
    self.buttonHasMoved = NO;
    if (!dragEnable) {
        return;
    }
    UIView *referenceView = nil;
    if (self.referenceView) {
        referenceView = self.referenceView;
    }else{
        referenceView = [[UIApplication sharedApplication] keyWindow];
    }
    CGFloat offsetX = CGRectGetMaxX(self.referenceView.frame) - self.frame.size.width/2;
    [UIView animateWithDuration:0.3
                          delay:0.
                        options:(UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         self.center = CGPointMake(offsetX, self.center.y);
                     }
                     completion:^(BOOL finished) {
                         CGPoint point = [self.superview convertPoint:self.frame.origin toView:self.referenceView];
                         self.superview.frame = CGRectMake(self.superview.frame.origin.x, point.y, self.superview.frame.size.width, self.superview.frame.size.height);
                         self.frame = CGRectMake(self.frame.origin.x,0,self.frame.size.width,self.frame.size.height);
                     }];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector]) {
        return [super methodSignatureForSelector:aSelector];
    }
    else {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:[anInvocation selector]]){
         [super forwardInvocation:anInvocation];
    }else{
        NSLog(@"selector %@ unreconginized selector!", NSStringFromSelector([anInvocation selector]));
        [KSDebugToastView toast:[NSString stringWithFormat:@"%@ crash because of doesNotRecognizeSelector %@", NSStringFromClass([self class]),NSStringFromSelector([anInvocation selector])] toView:self displaytime:3];
    }
}

@end
