//
//  ManWuFeedBackViewController.h
//  basicFoundation
//
//  Created by 许学 on 15/5/20.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSAdapterService.h"

@interface HSFeedBackViewController : KSViewController

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btn_commit;

@property (nonatomic, strong) KSAdapterService *service;

@end
