//
//  KSCancelButtonView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

typedef void (^doCancelBlock)  (void);

@interface KSCancelButtonView : KSView

@property (nonatomic, strong) UIButton                  *cancelButton;

@property (nonatomic, copy)   doCancelBlock              cancelBlock;

// override with subclass to opration cancel event
-(void)cancelEvent;

@end
