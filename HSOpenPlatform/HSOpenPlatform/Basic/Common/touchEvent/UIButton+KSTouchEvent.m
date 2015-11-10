//
//  UIButton+KSTouchEvent.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/20.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "UIButton+KSTouchEvent.h"
#import <objc/runtime.h>

static char KSTouchEventNotNeedLogKey;
static char KSTouchEventNameKey;
static char KSTouchEventAttributesKey;

@implementation UIView (KSTouchEvent)

#pragma 属性

-(BOOL)ks_notNeedEventLog
{
    return [objc_getAssociatedObject(self, &KSTouchEventNotNeedLogKey) boolValue];
}

-(void)ks_setNotNeedEventLog:(BOOL)notNeedEventLog
{
    objc_setAssociatedObject(self, &KSTouchEventNotNeedLogKey, [NSNumber numberWithInteger:notNeedEventLog], OBJC_ASSOCIATION_ASSIGN);
}

-(NSString*)ks_eventName
{
    return objc_getAssociatedObject(self, &KSTouchEventNameKey);
}

-(void)ks_setEventName:(NSString*)eventName{
    objc_setAssociatedObject(self, &KSTouchEventNameKey, eventName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary*)ks_eventAttributes{
    return objc_getAssociatedObject(self, &KSTouchEventAttributesKey);
}

-(void)ks_setEventAttributes:(NSDictionary*)eventAttributes{
    objc_setAssociatedObject(self, &KSTouchEventAttributesKey, eventAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIButton (KSTouchEvent)

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [KSTouchEvent touchWithView:self];
}

@end

@implementation UITableViewCell (KSTouchEvent)

-(void)KSSetSelected:(BOOL)selected animated:(BOOL)animated{
    [self KSSetSelected:selected animated:animated];
    if (selected && ![self isKindOfClass:NSClassFromString(@"WeAppTableViewCell")]) {
        [KSTouchEvent touchWithView:self];
    }
}

@end

@implementation UICollectionViewCell (KSTouchEvent)

-(void)KSSetSelected:(BOOL)selected{
    [self KSSetSelected:selected];
    if (selected && ![self isKindOfClass:NSClassFromString(@"KSCollectionViewCell")]) {
        [KSTouchEvent touchWithView:self];
    }
}

@end

@implementation UIGestureRecognizer (KSTouchEvent)

-(void)KSUpdateGestureWithEvent:(id)event buttonEvent:(id)buttonEvent{
    [self KSUpdateGestureWithEvent:event buttonEvent:buttonEvent];
    if ([self isKindOfClass:[UITapGestureRecognizer class]] || [self isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if ([self.view isKindOfClass:[UILabel class]]
            || [self.view isKindOfClass:[UIImage class]]
            || [self.view isKindOfClass:NSClassFromString(@"KSView")]
            || [self.view isKindOfClass:NSClassFromString(@"KSControl")]) {
            NSArray* getstureTargets = [self valueForKey:@"_targets"];
            if (getstureTargets && [getstureTargets isKindOfClass:[NSArray class]] && [getstureTargets count] > 0) {
                id gestureRecognizerTarget = [getstureTargets lastObject];
                if (gestureRecognizerTarget && ![[gestureRecognizerTarget valueForKey:@"target"] isKindOfClass:[UICollectionViewCell class]]) {
                    [self.view ks_setEventName:NSStringFromClass([self class])];
                    [KSTouchEvent touchWithView:self.view eventAttributes:@{@"gestureRecognizerTarget":gestureRecognizerTarget}];
                }
            }
        }
    }
}

@end
