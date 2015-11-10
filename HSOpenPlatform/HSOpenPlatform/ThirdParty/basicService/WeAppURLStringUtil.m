//
//  TBSNSURLStringUtil.m
//  Taobao2013
//
//  Created by 神逸 on 13-1-23.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppURLStringUtil.h"
#import "WeAppUtils.h"

@implementation WeAppURLStringUtil

+(NSString *)urlString:(NSString *)urlString addParams:(NSDictionary *)params {
    if (urlString.length<=0 || params == nil || params.count <= 0) {
        return urlString;
    }
    
    NSMutableString *urlWithParams = [NSMutableString stringWithFormat:@"%@?",urlString];
    
    for (NSString *key in params.allKeys) {
        [urlWithParams appendFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    
    return [urlWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)urlString:(NSString *)urlString addParams:(NSDictionary *)params addPagination:(WeAppPaginationItem *)pagination {
    
    if ([WeAppUtils isEmpty:urlString] || ([WeAppUtils isEmpty:params] && [WeAppUtils isEmpty:pagination])) {
        return urlString;
    }
    
    NSMutableDictionary *paramsWithPagination;
    
    if ([WeAppUtils isNotEmpty:params]) {
        paramsWithPagination = [NSMutableDictionary dictionaryWithDictionary:params];
    }else {
        paramsWithPagination = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    if (pagination) {
        if (pagination.paginationType == WeAppPaginationTypeDefault) {
            [paramsWithPagination setObject:[NSString stringWithFormat:@"%d", pagination.pageSize] forKey:@"pageSize"];
            [paramsWithPagination setObject:[NSString stringWithFormat:@"%d", pagination.curPage + 1] forKey:@"curPage"];
            [paramsWithPagination setObject:[NSString stringWithFormat:@"%llu", pagination.timestamp] forKey:@"timestamp"];
        }else{
            if (pagination.beforTimestamp > 0) {
                [paramsWithPagination setObject:[NSString stringWithFormat:@"%llu", pagination.beforTimestamp] forKey:@"timestamp"];
            }else{
                [paramsWithPagination setObject:[NSString stringWithFormat:@"%llu", pagination.afterTimestamp] forKey:@"timestamp"];
            }
            [paramsWithPagination setObject:[NSString stringWithFormat:@"%d", pagination.pageSize] forKey:@"pageSize"];
            
        }
    }

    return [WeAppURLStringUtil urlString:urlString addParams:paramsWithPagination];
}

@end
