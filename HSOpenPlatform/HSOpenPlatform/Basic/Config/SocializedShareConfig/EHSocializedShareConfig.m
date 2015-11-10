//
//  EHSocializedShareConfig.m
//  eHome
//
//  Created by xtq on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSocializedShareConfig.h"

@implementation EHSocializedShareConfig

+ (void)config{
    
    //友盟AppKey
    [UMSocialData setAppKey:kHS_UM_APPKEY];
    
    //微博SSO授权
    [UMSocialSinaHandler openSSOWithRedirectURL:kHS_WEIBO_URL];
    
    //设置微信AppId、appKey，分享url
    [UMSocialQQHandler setQQWithAppId:kHS_QQ_APPID appKey:kHS_QQ_APPKEY url:kHS_WEBSITE_URL];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kHS_WECHAT_APPID appSecret:kHS_WECHAT_APPSECRET url:kHS_WEBSITE_URL];
    
    //由于苹果审核政策需求，友盟建议对未安装客户端平台进行隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline]];

    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"来自：%@", kHS_APP_NAME];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"来自：%@",  kHS_APP_NAME];
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"来自：%@", kHS_APP_NAME];

}

@end
