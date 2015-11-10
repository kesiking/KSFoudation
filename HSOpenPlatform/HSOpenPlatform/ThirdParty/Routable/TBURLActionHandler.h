//
//  TBURLActionHandler.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBURLAction.h"

@protocol TBURLActionHandler <NSObject>

// 根据urlPath给urlAction的targetController赋值
- (BOOL)handleURLAction:(TBURLAction*)urlAction;

- (void)preprocessURLAction:(TBURLAction*)urlAction;

@end
