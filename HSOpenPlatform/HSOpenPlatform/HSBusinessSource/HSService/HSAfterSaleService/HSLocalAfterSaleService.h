//
//  HSLocalAfterSaleService.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSLocalAfterSaleModel.h"

@interface HSLocalAfterSaleService : KSAdapterService

- (void)getLocalAfterSaleWithAppId:(NSString *)appId PageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage;

@end
