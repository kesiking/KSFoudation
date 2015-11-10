//
//  TBSNSURLStringUtil.h
//  Taobao2013
//
//  Created by 神逸 on 13-1-23.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppPaginationItem.h"

@interface WeAppURLStringUtil : NSObject

+ (NSString*)urlString:(NSString*)urlString addParams:(NSDictionary*)params addPagination:(WeAppPaginationItem*)pagination;

+ (NSString*)urlString:(NSString*)urlString addParams:(NSDictionary*)params;

@end
