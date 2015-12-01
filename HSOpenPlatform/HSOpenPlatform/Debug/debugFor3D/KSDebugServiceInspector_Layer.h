//
//  WeAppDebugServiceInspector_Layer.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-9.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugImageView.h"

@interface KSDebugServiceInspector_Layer : KSDebugImageView

@property (nonatomic, assign) CGFloat		depth;
@property (nonatomic, assign) CGRect		rect;
@property (nonatomic, assign) UIView *		view;
@property (nonatomic, retain) UILabel *     label;

@end
