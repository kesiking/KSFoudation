//
//  UIButton+KSTouchEvent.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/20.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KSTouchEvent)

-(BOOL)ks_notNeedEventLog;

-(void)ks_setNotNeedEventLog:(BOOL)notNeedEventLog;

-(void)ks_setEventName:(NSString*)eventName;

-(NSString*)ks_eventName;

-(void)ks_setEventAttributes:(NSDictionary*)eventAttributes;

-(NSDictionary*)ks_eventAttributes;

@end

@interface UIButton (KSTouchEvent)

@end

@interface UITableViewCell (KSTouchEvent)

-(void)KSSetSelected:(BOOL)selected animated:(BOOL)animated;

@end

@interface UICollectionViewCell (KSTouchEvent)

-(void)KSSetSelected:(BOOL)selected;

@end

@interface UIGestureRecognizer (KSTouchEvent)

-(void)KSUpdateGestureWithEvent:(id)event buttonEvent:(id)buttonEvent;

@end
