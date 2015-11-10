//
//  TBSNSPaginationItem.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_PAGE_SIZE 10

/**翻页枚举类型***/
typedef enum {
    WeAppPaginationTypeDefault = 0,     //0---默认，from、count、timestamp实现翻页
    WeAppPaginationTypeTimeStamp,       //1---afterTimestamp、beforTimestamp、totalCount实现翻页
    WeAppPaginationTypeId,              //2---通过id翻页
    WeAppPaginationTypeALL              //3---包含所有的翻页方式
}WeAppPaginationType;

typedef enum {
    WeAppPaginationTimestampAfter = 0,  //0---默认，取该时间之后的数据
    WeAppPaginationTimestampBefor,      //1---取该时间之前的数据
}WeAppPaginationTimestamp;

typedef enum {
    WeAppPaginationDirectionRefresh = -1, // 刷新 AfterTimestamp
    WeAppPaginationDirectionBetweenTimestampAndNow = 0,// 当前时间与timestamp
    WeAppPaginationDirectionNextPage = 1// 翻页 BeforeTimestamp之间的数据
}WeAppPaginationDirection;

#define ACCOUNT_RECOMMAND_ORDER_FAN @"fans"
#define ACCOUNT_RECOMMAND_ORDER_LASTFEEDTIME @"lastFeedTime"

@interface WeAppPaginationItem : NSObject
{
    
    BOOL    _isTimestampEnable;//是否使用时间戳取数据，默认为NO
    
    int     _pageSize;
    int     _reallyCurpage;
    int     _curPage;
    unsigned long long    _timestamp; //时间戳，可选，用于在快速变化的数据中进行分页
    
    unsigned long long    _afterTimestamp;
    unsigned long long    _beforTimestamp;
    
    unsigned long long    _id;  // id翻页
}


@property (nonatomic, assign) int                       reallyCurpage;
@property (nonatomic, assign) int                       curPage;
@property (nonatomic, assign) int                       pageSize;
@property (nonatomic, assign) WeAppPaginationDirection                       direction;
@property (nonatomic, assign) unsigned long long        timestamp;

@property (nonatomic, assign) unsigned long long        afterTimestamp;
@property (nonatomic, assign) unsigned long long        beforTimestamp;
@property (nonatomic, assign) unsigned long long        id;
@property (nonatomic, assign) BOOL                      isTimestampEnable;
@property (nonatomic, assign) WeAppPaginationType       paginationType;
@property (nonatomic, assign) WeAppPaginationTimestamp  paginationTimestamp;

// 是否使用timestamp作为参照物，比如在某timestamp之前的数据；如果不使用，则会将timestamp设置为0，含义是取最新的数据；默认为不使用
@property (nonatomic) BOOL useTimesatmpAsReference;

-(void)paginationPlus;
-(void)reset;
-(long)currentPageNums;
-(void)setPagination:(WeAppPaginationItem*) pagination;

- (void)addParams:(NSDictionary*)params withDict:(NSMutableDictionary*)dict;

@end
