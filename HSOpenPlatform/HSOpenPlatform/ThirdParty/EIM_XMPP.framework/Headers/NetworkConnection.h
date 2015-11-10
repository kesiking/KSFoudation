//
//  NetworkConnection.h
//  Leshi
//
//  Created by 杨晓东 on 14-9-25.
//  Copyright (c) 20. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef void(^successful) (NSString *repsonArray);
typedef void(^fail) (NSError *error);

@interface NetworkConnection : NSObject

-(id)initWithURL:(NSString *)aurl
      successful:(successful )asuccessful
            fail:(fail )error;


@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)successful success;
@property (nonatomic,copy)fail fai;
@property (nonatomic,retain)NSMutableData *data;
@property (nonatomic ,retain)NSURLConnection * connection;
-(void)handleget;

@end
