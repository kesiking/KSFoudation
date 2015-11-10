//
//  BasicNetWorkAdapter.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-16.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "BasicNetWorkAdapter.h"

@implementation BasicNetWorkAdapter

-(void)request:(NSString*)apiName
     withParam:(NSDictionary*)param
     onSuccess:(NetworkSuccessBlock)successBlock
       onError:(NetworkErrorBlock)errorBlock
      onCancel:(NetworkCancelBlock)cancelBlock{
    
}

-(void)uploadfile:(NSString *)apiName withFileName:(NSString*)fileName withFileContent: (NSData*)fileContent withParam:(NSDictionary *)param onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock
{
    
}

@end
