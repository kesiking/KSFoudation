//
//  KSMainViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSViewController.h"
#import "EHTabBarViewController.h"
#import "KSTabBarViewControllerProtocol.h"

@interface KSTabBasicViewController : KSViewController<KSTabBarViewControllerProtocol>

@property(nonatomic,assign) BOOL                 needLogin;

@property(nonatomic,strong) UIBarButtonItem     *leftBarButtonItem;

@property(nonatomic,strong) UIView              *titleView;

@property(nonatomic,strong) UIBarButtonItem     *rightBarButtonItem;

-(BOOL)checkLogin;

-(void)alertCheckLoginWithCompleteBlock:(dispatch_block_t)completeBlock;

-(void)doLogin;

-(void)userDidLogin:(NSDictionary*)userInfo;

-(void)userDidLogout:(NSDictionary*)userInfo;

@end