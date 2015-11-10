//
//  UIScrollViewSpeed.h
//  Taobao2013
//
//  Created by 香象 on 21/4/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeAppUIScrollViewSpeed : NSObject

@property(assign,nonatomic) CGPoint lastOffset;
@property(assign,nonatomic) NSTimeInterval lastOffsetCapture;
@property(assign,nonatomic) CGFloat scrollSpeed;
@property(strong,nonatomic) void (^speedChanged)(CGFloat currentSpeed);


-(void)calculateSpeedWithScrollView:(UIScrollView *)scrollView;
-(void)reset;
@end
