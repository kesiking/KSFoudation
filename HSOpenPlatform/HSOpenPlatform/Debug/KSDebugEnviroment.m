//
//  WeAppDebugEnviroment.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugEnviroment.h"
#import "KSDebugRequestHostCenter.h"

@implementation KSDebugEnviroment

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    _filePathArray = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
    if (logsDirectory) {
        [_filePathArray addObject:logsDirectory];
    }
    
    NSString *sdImageDirectory  = [baseDir stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    if (sdImageDirectory) {
        [_filePathArray addObject:@{@"filePath":sdImageDirectory,@"fileType":@"png"}];
    }
    
}
-(void)setOrignalHost:(NSString *)orignalHost{
    _orignalHost = orignalHost;
    [[KSDebugRequestHostCenter sharedInstance] setOrignalHost:orignalHost];
}

-(void)setOrignalPort:(NSString *)orignalPort{
    _orignalPort = orignalPort;
    [[KSDebugRequestHostCenter sharedInstance] setOrignalPort:orignalPort];
}

-(void)setRedirectHost:(NSString *)redirectHost{
    _redirectHost = redirectHost;
    [[KSDebugRequestHostCenter sharedInstance] setRedirectHost:redirectHost];
}

-(void)setRedirectPort:(NSString *)redirectPort{
    _redirectPort = redirectPort;
    [[KSDebugRequestHostCenter sharedInstance] setRedirectPort:redirectPort];
}


@end
