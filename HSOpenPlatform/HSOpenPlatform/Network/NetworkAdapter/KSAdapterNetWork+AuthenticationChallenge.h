//
//  KSAdapterNetWork+AuthenticationChallenge.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/20.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterNetWork.h"

@interface KSAdapterNetWork (AuthenticationChallenge)

- (void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))getAuthenticationChallengeBlock;


@end
