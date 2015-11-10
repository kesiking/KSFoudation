//
//  TBNavigationParams.m
//  Taobao2013
//
//  Created by 晨燕 on 13-2-5.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "TBNavigationParams.h"

@implementation TBNavigationParams

- (id)init {
    if (self = [super init]) {
        self.navigationType = TBNavigationTypePush;
        self.animated = YES;
        self.needNavigationCtrl = NO;
        self.needLogin = NO;
        self.needSafeCode = NO;
        self.needDissmiss = YES;
    }
    return self;
}

- (NSString *)stringofNavigationParams {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (self.target) {
        [dic setObject:self.target forKey:@"target"];
    }
    if (!self.animated) {
        [dic setObject:[NSString stringWithFormat:@"%d", self.animated] forKey:@"animated"];
    }
    if (self.needNavigationCtrl) {
        [dic setObject:[NSString stringWithFormat:@"%d", self.needNavigationCtrl] forKey:@"neednavigationctrl"];
    }
    if (self.needLogin) {
        [dic setObject:[NSString stringWithFormat:@"%d", self.needLogin] forKey:@"needlogin"];
    }
    if (self.needSafeCode) {
        [dic setObject:[NSString stringWithFormat:@"%d", self.needSafeCode] forKey:@"needsafecode"];
    }
    if (self.navigationType != TBNavigationTypePush) {
        [dic setObject:stringofNavigationType(self.navigationType) forKey:@"navigationtype"];
    }
    if (!self.needDissmiss) {
        [dic setObject:[NSString stringWithFormat:@"%d", self.needDissmiss] forKey:@"needdismiss"];
    }
    if ([[dic allKeys] count] > 0) {
        return [NSString stringWithFormat:@"%@=%@",kTBNavigationParamsKey,[[dic JSONString] tbUrlEncoded]];
    } else {
        return @"";
    }
}


+ (TBNavigationParams *)navigationParamsofDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    TBNavigationParams* params = [[TBNavigationParams alloc] init];
    NSString* type = [dic objectForKey:@"navigationtype"];
    params.navigationType = type ? navigationTypeofString(type) : TBNavigationTypePush;
    params.target = [dic objectForKey:@"target"];
    params.animated = [dic objectForKey:@"animated"] ? [[dic objectForKey:@"animated"] boolValue] : YES;    
    params.needNavigationCtrl = [dic objectForKey:@"neednavigationctrl"] ? [[dic objectForKey:@"neednavigationctrl"] boolValue] : NO;
    params.needLogin = [dic objectForKey:@"needlogin"] ? [[dic objectForKey:@"needlogin"] boolValue] : NO;
    params.needSafeCode = [dic objectForKey:@"needsafecode"] ? [[dic objectForKey:@"needsafecode"] boolValue] : NO;
    params.needDissmiss = [dic objectForKey:@"needdismiss"] ? [[dic objectForKey:@"needdismiss"] boolValue] : YES;
    return params;
}


@end
