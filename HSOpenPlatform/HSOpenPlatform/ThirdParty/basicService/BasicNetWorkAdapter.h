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

@interface BasicNetWorkAdapter : NSObject

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

@end
