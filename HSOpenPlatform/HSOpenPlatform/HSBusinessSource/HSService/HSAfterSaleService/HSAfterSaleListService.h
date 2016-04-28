//
//  HSAfterSaleListService.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/24.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSAfterSaleModel.h"

@interface HSAfterSaleListService : KSAdapterService

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (void)getAfterSaleListWithProductId:(NSNumber *)productId PageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage;

@end
