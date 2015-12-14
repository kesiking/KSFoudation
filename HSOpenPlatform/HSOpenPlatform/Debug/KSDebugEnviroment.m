//
//  WeAppDebugEnviroment.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugEnviroment.h"

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


@end
