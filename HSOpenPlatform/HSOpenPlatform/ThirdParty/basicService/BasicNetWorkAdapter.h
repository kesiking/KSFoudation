//
//  BasicNetWorkAdapter.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-16.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeAppServiceContext.h"

typedef void(^NetworkSuccessBlock)(NSDictionary* json);
typedef void(^NetworkErrorBlock)(NSDictionary* json);
typedef void(^NetworkCancelBlock)(NSDictionary* json);

typedef void (^NetworkProgressBlock)(NSUInteger currentSendBytes, long long currentSendTotleBytes, long long totalBytes);

@interface BasicNetWorkAdapter : NSObject

@property (nonatomic, copy) NetworkProgressBlock        uploadProgress;
@property (nonatomic, copy) NetworkProgressBlock        downloadProgress;

-(void)request:(NSString*)apiName
     withParam:(NSMutableDictionary*)param
serviceContext:(WeAppServiceContext*)serviceContext
     onSuccess:(NetworkSuccessBlock)successBlock
       onError:(NetworkErrorBlock)errorBlock
       onCancel:(NetworkCancelBlock)cancelBlock;

-(void)uploadfile:(NSString *)apiName
     withFileName:(NSString*)fileName
  withFileContent:(NSData*)fileContent
        withParam:(NSMutableDictionary *)param
   serviceContext:(WeAppServiceContext*)serviceContext
        onSuccess:(NetworkSuccessBlock)successBlock
          onError:(NetworkErrorBlock)errorBlock
         onCancel:(NetworkCancelBlock)cancelBlock;

-(void)cancelRequest:(NSString*)apiName
           withParam:(NSDictionary*)param;

@end
