//
//  KSDebugToastView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/4.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugToastView.h"
#import "KSDebugMaroc.h"

#define hinttag 11723
#define confirmHinttag 11725

@implementation KSDebugToastView

+(void)toast:(NSString*)s{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if (window == nil && [[[UIApplication sharedApplication] windows] count] > 0) {
        window = [[[UIApplication sharedApplication] windows] lastObject];
    }
    [self toast:s toView:window];
}

+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t{
    [self toast:s toView:v displaytime:t postion:CGPointZero withCallBackBlock:nil];
}

+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(CGPoint)position withCallBackBlock:(void (^)(UIView* toastView, UILabel* toastLabel))callBackBlock{
    if (s == nil || s.length == 0) {
        NSLog(@"----> toast error because string is nil or length is 0");
        return;
    }
    @synchronized([self class]) {
        
        UIView*h=[v viewWithTag:hinttag];
        if (h) {
            NSLog(@"----> toast error because hinttag %d is on window",hinttag);
            return;
        }
        if(h==nil){
            int padding=30;
            //宽度固定长度扩展
            UILabel*l = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, 230, 30)];
            l.numberOfLines=0;
            l.textAlignment=NSTextAlignmentCenter;
            l.text=s;
            l.font=[UIFont boldSystemFontOfSize:15];
            l.textColor=[UIColor whiteColor];
            l.backgroundColor=[UIColor clearColor];
            [l sizeToFit];
            if (CGPointEqualToPoint(CGPointZero, position)) {
                h = [[UIView alloc] initWithFrame:CGRectMake((v.frame.size.width-l.frame.size.width-padding)/2, (v.frame.size.height-l.frame.size.height-padding)/2,l.frame.size.width+padding, l.frame.size.height+padding)];
            }else
            {
                h = [[UIView alloc] initWithFrame:CGRectMake(position.x, position.y,l.frame.size.width+padding, l.frame.size.height+padding)];
            }
            
            h.tag=hinttag;
            h.layer.cornerRadius=7;
            h.layer.borderColor = KSDebugRGB(0x84, 0x83, 0x83).CGColor;
            h.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
            
            if (callBackBlock) {
                callBackBlock(h,l);
            }
            
            [h addSubview:l];
        }
        
        [v addSubview:h];
        
        NSLog(@"----> toast sucsess with string is %@",s);
        
        [UIView animateWithDuration:.3 delay:t options:UIViewAnimationOptionCurveEaseInOut animations:^{
            h.alpha=0;
        } completion:^(BOOL finished){
            [h removeFromSuperview];
        }];
        
    }
}

+(void)toast:(NSString*)s toView:(UIView*)v{
    [self toast:s toView:v displaytime:3.5];
}

@end
