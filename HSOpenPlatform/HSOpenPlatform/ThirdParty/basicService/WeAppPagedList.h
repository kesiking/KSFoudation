//
//  TBCAPagedList.h
//  TBWeiTao
//
//  Created by 逸行 on 14-3-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "WeAppBasicPagedList.h"


@interface WeAppPagedList : WeAppBasicPagedList

@property (nonatomic, strong) id jsonValue;

//根据object刷新pagelist数据
-(void)refreshPageListWithObject:(id)object;

@end
