//
//  AppDelegate.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/9/29.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "AppDelegate.h"
#import "EHSocializedShareConfig.h"
#import "EHTabBarViewController.h"
#import "KSDebugManager.h"
#import "MQTTClientShareInstance.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [EHLog initEHLog];
    
    [self configRemoteNotificationWithApplication:application launchingWithOptions:launchOptions];
    [self configUIContent];
    [self configApplication];
    [EHSocializedShareConfig config];

    return YES;
}

-(void)configApplication{
    // 读取配置文件
    [KSConfigCenter configMatrix];
    // 配置Navigator，支持全局url跳转
    [KSBasicNavigator configNavigator];
    // 检查是否登录
    [[KSAuthenticationCenter sharedCenter] autoLoginWithCompleteBlock:nil];
    // 配置自动埋点
    [KSTouchEvent configTouch];
    // 发布时应该关掉
#ifdef DEBUG_ENVIEONMENT
    [KSTouchEvent setNeedTouchEventLog:YES];
#endif
    // 启动并配置友盟
    [MobClick startWithAppkey:kHS_UM_APPKEY reportPolicy:SENDWIFIONLY channelId:nil];
    [MobClick setAppVersion:[HSDeviceDataCenter appShortVersion]];
#ifdef DEBUG_ENVIEONMENT
    #ifdef DEBUG
    [MobClick setLogEnabled:YES];
    #endif
#endif
    [KSDebugManager setupDebugManager];
    
    [[MQTTClientShareInstance sharedCenter] publishMessageToDefaultTopic:@"contect"];
}

-(void)configUIContent{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController: [[EHTabBarViewController alloc] init]];
    navigationController.navigationBar.translucent = NO;
    if([navigationController.navigationBar respondsToSelector:@selector(barTintColor)]){
        navigationController.navigationBar.barTintColor = UINAVIGATIONBAR_COLOR;
    }
    if([navigationController.navigationBar respondsToSelector:@selector(tintColor)]){
        navigationController.navigationBar.tintColor  =   UINAVIGATIONBAR_TITLE_COLOR;
    }
    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    // 修改navbar title颜色
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               UINAVIGATIONBAR_TITLE_COLOR, NSForegroundColorAttributeName,
                                               [UIFont boldSystemFontOfSize:UINAVIGATIONBAR_TITLE_SIZE], NSFontAttributeName,nil];
    
    [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    self.window.rootViewController = navigationController;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)configRemoteNotificationWithApplication:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions {
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    // 点击消息进入的页面
    if (launchOptions) {
        // do something else
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    
}

- (void)cancelAllNotificationMessage{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
