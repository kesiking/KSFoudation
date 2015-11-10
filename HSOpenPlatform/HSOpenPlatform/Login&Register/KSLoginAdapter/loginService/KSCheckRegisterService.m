//
//  KSCheckRegisterService.m
//  eHome
//
//  Created by 孟希羲 on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSCheckRegisterService.h"
#import "KSLoginService.h"

@interface KSCheckRegisterService()

@property (nonatomic, strong) KSLoginService        *checkAccountNameService;

@property (nonatomic, copy) checkRegisterBlock       checkRegister;

@end

@implementation KSCheckRegisterService

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)checkRegisterWithAccountName:(NSString*)accountName checkRegister:(checkRegisterBlock)checkRegister{
    if (checkRegister && checkRegister != self.checkRegister) {
        self.checkRegister = nil;
        self.checkRegister = checkRegister;
    }
    [self.checkAccountNameService checkAccountName:accountName];
}

-(KSLoginService *)checkAccountNameService{
    if (_checkAccountNameService == nil) {
        _checkAccountNameService = [[KSLoginService alloc] init];
        [self setupCheckAccountNameService];
    }
    return _checkAccountNameService;
}

-(void)setupCheckAccountNameService{
    
    WEAKSELF
    _checkAccountNameService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        if (strongSelf.checkRegister) {
            strongSelf.checkRegister(NO,nil);
        }
    };
    
    _checkAccountNameService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        if (strongSelf.checkRegister) {
            NSRange range = [errorInfo rangeOfString:@"此用户手机号码已经注册"];
            if (errorInfo && range.location != NSNotFound) {
                strongSelf.checkRegister(YES,error);
            }else{
                strongSelf.checkRegister(NO,error);
            }
        }
    };
    
}

@end
