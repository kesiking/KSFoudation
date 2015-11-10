//
//  KSAuthenticationCenter.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-11.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAuthenticationCenter.h"
#import "KSLoginComponentItem.h"
#import "KSLoginService.h"
#import "EHAleatView.h"
#import "KSNetworkDataMock.h"

#define ISNotFirstLoadApplication  @"isNotFirstLoadApplication"

@interface KSAuthenticationCenter(){
    
}

@property (nonatomic, strong)     KSLoginService*       logoutService;

@property (nonatomic, strong)     KSLoginService*       autoLoginService;

@property (nonatomic, strong)     NSMutableArray*       logoutCompleteBlockArray;

@end

@implementation KSAuthenticationCenter

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public



+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

+ (NSString*)userId{
    if (![self isLogin]) {
        return nil;
    }
    id userIdObj = [KSLoginComponentItem sharedInstance].userId;
    if (userIdObj) {
        return [NSString stringWithFormat:@"%@",userIdObj];
    }
    return nil;
}

+ (NSString*)userPhone{
    if (![self isLogin]) {
        return nil;
    }
#ifdef MOCK_USER_PHONE
    return [[KSNetworkDataMock sharedInstantce] getJsonDataWithKey:@"userPhone"];
#else
    id userPhoneObj = [KSLoginComponentItem sharedInstance].user_phone;
    if (userPhoneObj) {
        return [NSString stringWithFormat:@"%@",userPhoneObj];
    }
    return nil;
#endif
}

+ (NSString*)preUserPhone{
    if (![self isLogin]) {
        return kTestAccountName;
    }
    id preUserPhoneObj = [KSLoginComponentItem sharedInstance].pre_user_phone;
    if (preUserPhoneObj) {
        return [NSString stringWithFormat:@"%@",preUserPhoneObj];
    }
    return nil;
}

+(KSLoginComponentItem*)userComponent{
    if (![self isLogin]) {
        return nil;
    }
    return [KSLoginComponentItem sharedInstance];
}

+ (BOOL)isLogin{
    return [KSLoginComponentItem sharedInstance].isLogined;
}

+(BOOL)isTestAccount{
    return [[self userPhone] isEqualToString:kTestAccountName];
}

+ (void)logoutWithCompleteBolck:(dispatch_block_t)completeBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock) {
            @synchronized([KSAuthenticationCenter sharedCenter]){
                [[KSAuthenticationCenter sharedCenter].logoutCompleteBlockArray addObject:[completeBlock copy]];
            }
        }
    });
    
    [[KSAuthenticationCenter sharedCenter].logoutService logoutWithAccountName:[self userId]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    _logoutCompleteBlockArray = [NSMutableArray array];
    [self setupUserCenterNotification];
}

-(void)setupUserCenterNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginNotification:) name:kUserLoginSuccessNotification object:nil];
}

-(KSLoginService *)logoutService{
    if (_logoutService == nil) {
        _logoutService = [KSLoginService new];
        WEAKSELF
        _logoutService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized(strongSelf){
                    for (dispatch_block_t block in strongSelf.logoutCompleteBlockArray) {
                        if (block) {
                            block();
                        }
                    }
                    [strongSelf.logoutCompleteBlockArray removeAllObjects];
                }
            });
            
        };
        _logoutService.serviceDidFailLoadBlock = ^(WeAppBasicService *service, NSError *error){
            [WeAppToast toast:@"登出失败，请稍微再试"];
        };
    }
    return _logoutService;
}

-(KSLoginService *)autoLoginService{
    if (_autoLoginService == nil) {
        _autoLoginService = [KSLoginService new];
        WEAKSELF
        _autoLoginService.serviceDidFailLoadBlock = ^(WeAppBasicService *service, NSError *error){
            STRONGSELF
            // 登录失败后先登出操作，然后做弹出登陆框
            NSRange range = [[error.userInfo objectForKey:NSLocalizedDescriptionKey] rangeOfString:@"未能连接到服务器"];
            // 异常逻辑处理，登录失败有可能是没有网络造成，根据AFNetworkReachabilityManager的状态或是错误状态判断是否为无网络
            if (range.location != NSNotFound || ![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                // 无网络提示
                [[KSLoginComponentItem sharedInstance] updateUserLogin:NO];
                TBOpenURLFromTargetWithNativeParams(loginURL, [UIApplication sharedApplication].keyWindow.rootViewController, @{@"needNavigationBar":@"false"}, nil);
                [strongSelf showAlertWithReachabilityStatus];
            }else{
                [KSAuthenticationCenter logoutWithCompleteBolck:^{
                    TBOpenURLFromTargetWithNativeParams(loginURL, [UIApplication sharedApplication].keyWindow.rootViewController, @{@"needNavigationBar":@"false"}, nil);
                }];
            }
        };
    }
    return _autoLoginService;
}

-(void)authenticateWithAlertViewMessage:(NSString*)message LoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock source:(id)source{
    BOOL isLogin = [[self class] isLogin];
    if (!isLogin) {
        EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:message clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
            if (index == 1) {
                [self authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock source:source];
            }else if (cancelActionBlock) {
                cancelActionBlock();
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aleatView show];
    }else if (loginActionBlock) {
        loginActionBlock(YES);
    }
}

- (void)authenticateWithLoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock{
    [self authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock source:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)authenticateWithLoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock source:(id)source{
    if ([[self class] isLogin]) {
        if (loginActionBlock) {
            loginActionBlock(YES);
        }
    }else{
        NSMutableDictionary* callBacks = [NSMutableDictionary dictionary];
        if (loginActionBlock) {
            [callBacks setObject:loginActionBlock forKey:kLoginSuccessBlock];
        }
        
        if (cancelActionBlock) {
            [callBacks setObject:cancelActionBlock forKey:kLoginCancelBlock];
        }
        
        TBOpenURLFromTargetWithNativeParams(loginURL, source, @{@"needNavigationBar":@"false"}, callBacks);
    }
}

- (void)autoLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    NSString* accountName = [[KSLoginComponentItem sharedInstance] getAccountName];
    NSString* password = [[KSLoginComponentItem sharedInstance] getPassword];
    if (accountName == nil || password == nil || ![KSAuthenticationCenter isLogin]) {
        TBOpenURLFromTargetWithNativeParams(loginURL, [UIApplication sharedApplication].keyWindow.rootViewController, @{@"needNavigationBar":@"false"}, nil);
    }else{
        [self.autoLoginService loginWithAccountName:accountName password:password];
    }
}

- (void)repeatLoginAleatViewWithMessage:(NSString*)message loginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock{
    __weak __block UIViewController* weakVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:message clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
        __strong UIViewController* strongVC = weakVC;
        if (index == 0) {
            [KSAuthenticationCenter logoutWithCompleteBolck:^{
                [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock source:strongVC];
            }];
        }
    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [aleatView show];
}

-(void)showAlertWithReachabilityStatus{
    //网络变化 
    static BOOL didFirstShowAlertView = NO;
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        if (didFirstShowAlertView) {
            EHAleatView *alert = [[EHAleatView alloc] initWithTitle:UILOGIN_NETWORK_ERROR_TITLE message:UILOGIN_NETWORK_ERROR_MESSAGE clickedButtonAtIndexBlock:^(EHAleatView *alertView, NSUInteger index) {
                if (index == 1) {
                    if (IOS_VERSION >= 8.0) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
                    }
                }
            } cancelButtonTitle:@"确定" otherButtonTitles:@"设置",nil];
            [alert show];
            didFirstShowAlertView = NO;
        }else{
            [WeAppToast toast:@"当前网络异常，请检查您的网络！"];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)userDidLoginNotification:(NSNotification*)notification{
    //最后,在登录账户成功后调用订阅推送接口:
    [KSTouchEvent profileSignInWithPUID:[KSAuthenticationCenter userPhone]];
}

-(void)userDidLogoutNotification:(NSNotification*)notification{
    //在退出账号登录后调用此接口,可取消推送 
    [KSTouchEvent profileSignOff];
}

@end
