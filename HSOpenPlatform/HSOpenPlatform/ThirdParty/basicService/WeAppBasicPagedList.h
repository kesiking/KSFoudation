//
//  TBSNSItemList.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//
#import "WeAppItemList.h"
#import "WeAppUtils.h"
#import "WeAppPaginationItem.h"
#import "WeAppUtils.h"

typedef BOOL(^IsSameObjectCompareBlock)(id obj1, id obj2);
typedef BOOL(^IsObjectEnableBlock)(id obj);

/**
 SNS数据请求使用Pagination实现分页操作
 扩展已有的TBItemList，实现支持SNS的分页操作
 **/

@class WeAppBasicPagedList;

@protocol TBSNSPageListProtocol <NSObject>

//是否需要底层解析pageList数据，默认返回YES，由底层统一解析，否则由TBSNSPagedList子类解析
-(BOOL)shouldPageListParse;

//开始解析前调用
-(void)willParsedPageListWithJsonValue:(NSDictionary*)jsonValue;

//解析时调用
-(void)parsePageListWithJsonValue:(NSDictionary*)jsonValue;

//解析完后调用
-(void)didFinishedParsedPageListWithJsonValue:(NSDictionary*)jsonValue;

@property (nonatomic, copy) Class           itemClass;

@end

@interface WeAppBasicPagedList : WeAppItemList<TBSNSPageListProtocol>{
    WeAppPaginationItem*   _pagination;
}

@property (nonatomic, strong,setter = setPagination:) WeAppPaginationItem*   pagination;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic) BOOL isForceRemoveAllObject;//强制删除
@property (nonatomic) BOOL isForceRecordAllObject;//强制保留
@property (nonatomic) BOOL isNeedRefresh;
@property (nonatomic, strong) NSString* listPath;

// contentoffset用于记录pagelist的tableview滑动的位置
@property (nonatomic) CGPoint contentoffset;

-(void)paginationPlus;
-(void)refresh;
-(void)nextPage;

-(void)refreshWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;
-(void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;

-(LongTimeType)timestampAtIndex:(NSInteger)index;

// 去重
-(void)unique;
// 根据IsSameObjectCompareBlock自定义是否两个对象相同，再去去重
-(void)uniqueWithBlock:(IsSameObjectCompareBlock)isSameObjectCompareBlock;
-(void)orderByTimestampDesc;
-(void)orderUsingComparator:(NSComparator)cmptr;
//是否有重复的数据需要去处
-(BOOL)addNeedRemoveDataToArray:(id)object;
-(BOOL)hasRepeatData;
-(void)deleteRepeatData;
@end
