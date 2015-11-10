//
//  UIView+Geometry.m
//  TBUtility
//
//  Created by lv on 14-4-2.
//
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (UIViewController*)viewController {
    for (UIView* next=self; next; next=next.superview) {
        if ([next.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next.nextResponder;
        }
    }
    return nil;
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

-(void)removeAllSubviews{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

-(id)getEnableViewFromSuperView:(IsViewEnableBlock)IsViewEnableBlock{
    id obj = self;
    while (obj != nil && [obj isKindOfClass:[UIView class]]) {
        if (obj == nil) {
            break;
        }
        if (IsViewEnableBlock && IsViewEnableBlock(obj)) {
            return obj;
            break;
        }
        obj = [obj superview];
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Accessors

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
