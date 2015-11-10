//
//  EHMyInfoViewController.h.h
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"

@interface EHMyInfoViewController : KSViewController

@end




typedef void (^LogOutBlock) ();

@interface EHLogOutAlertView : KSView

@property (nonatomic, strong)LogOutBlock logOutBlock;

- (void)show;

@end