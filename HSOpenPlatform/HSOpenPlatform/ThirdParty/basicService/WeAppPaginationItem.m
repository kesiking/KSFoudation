//
//  TBSNSPaginationItem.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppPaginationItem.h"

@implementation WeAppPaginationItem

@synthesize curPage = _curPage;
@synthesize reallyCurpage = _reallyCurpage;
@synthesize direction = _direction;
@synthesize timestamp=_timestamp;
@synthesize afterTimestamp = _afterTimestamp;
@synthesize beforTimestamp = _beforTimestamp;
@synthesize id = _id;
@synthesize isTimestampEnable = _isTimestampEnable;
@synthesize paginationType = _paginationType;
@synthesize paginationTimestamp = _paginationTimestamp;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (id)init {
    if (self = [super init]) {
        
        self.reallyCurpage = 0;
        self.curPage = 0;
        self.direction = 1;//默认向后翻
        self.timestamp = 0;
        
        self.afterTimestamp = 0;
        self.beforTimestamp = 0;
        self.id = 0;
        self.isTimestampEnable = NO;
        self.pageSize = DEFAULT_PAGE_SIZE;
        self.paginationType = WeAppPaginationTypeDefault;
        self.paginationTimestamp = WeAppPaginationTimestampAfter;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)reset {
    
    self.timestamp = 0;
    self.reallyCurpage = 0;
    self.curPage = 0;
    self.direction = 1;//默认向后翻
    
    self.afterTimestamp = 0;
    self.beforTimestamp = 0;
    self.id = 0;
    self.isTimestampEnable = NO;
}

-(long)currentPageNums{
    return self.pageSize * self.curPage;
}

-(void)paginationPlus{
    if (self.paginationType == WeAppPaginationTypeDefault || self.paginationType == WeAppPaginationTypeALL) {
        if (self.isTimestampEnable) {
            //mtop新接口
            self.reallyCurpage++;
            self.curPage = self.reallyCurpage;
        }
    }
    
}

-(void)setPagination:(WeAppPaginationItem*) pagination{
    if (pagination) {
        self.curPage = pagination.curPage;
        self.pageSize = pagination.pageSize;
        self.reallyCurpage = pagination.reallyCurpage;
        self.direction = pagination.direction;

        if (pagination.paginationType == WeAppPaginationTypeDefault) {
            self.timestamp = pagination.timestamp;
        } else if(pagination.paginationType == WeAppPaginationTypeId) {
            self.id = pagination.id;
        }else if(pagination.paginationType == WeAppPaginationTypeALL){
            self.timestamp = pagination.timestamp;
            self.id = pagination.id;
            self.afterTimestamp = pagination.afterTimestamp;
            self.beforTimestamp = pagination.beforTimestamp;
            self.paginationTimestamp = pagination.paginationTimestamp;
        }else{
            self.afterTimestamp = pagination.afterTimestamp;
            self.beforTimestamp = pagination.beforTimestamp;
            self.paginationTimestamp = pagination.paginationTimestamp;
        }
                
        self.paginationType = pagination.paginationType;
        self.isTimestampEnable = pagination.isTimestampEnable;
    }
}

- (void)addParams:(NSDictionary*)params withDict:(NSMutableDictionary*)dict{
    if (dict && [dict isKindOfClass:[NSMutableDictionary class]]) {
        
        id curPageName = nil;
        id timestampName = nil;
        id idStampName = nil;
        id pageSizeName = nil;
        id directionName = nil;
        
        //获取数据
        if (params && [params count] > 0) {
            curPageName = [params objectForKey:@"curPageName"];
            if (curPageName == nil || ![curPageName isKindOfClass:[NSString class]]) {
                curPageName = [NSString stringWithFormat:@"curPage"];
            }
            timestampName = [params objectForKey:@"timestampName"];
            if (timestampName == nil || ![timestampName isKindOfClass:[NSString class]]) {
                timestampName = [NSString stringWithFormat:@"timestamp"];
            }
            idStampName = [params objectForKey:@"idName"];
            if (idStampName == nil || ![idStampName isKindOfClass:[NSString class]]) {
                idStampName = [NSString stringWithFormat:@"id"];
            }
            pageSizeName = [params objectForKey:@"pageSizeName"];
            if (pageSizeName == nil || ![pageSizeName isKindOfClass:[NSString class]]) {
                pageSizeName = [NSString stringWithFormat:@"pageSize"];
            }
            directionName = [params objectForKey:@"directionName"];
            if (directionName == nil || ![directionName isKindOfClass:[NSString class]]) {
                directionName = [NSString stringWithFormat:@"direction"];
            }
        }else{
            curPageName = [NSString stringWithFormat:@"curPage"];
            timestampName = [NSString stringWithFormat:@"timestamp"];
            idStampName = [NSString stringWithFormat:@"id"];
            pageSizeName = [NSString stringWithFormat:@"pageSize"];
            directionName = [NSString stringWithFormat:@"direction"];
        }
        
        if (self.paginationType == WeAppPaginationTypeDefault) {
            [dict setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:((NSString*)pageSizeName)];
            //            pagination.curPage = pagination.reallyCurpage + 1;
            if (self.isTimestampEnable && self.reallyCurpage == 0) {
                //已经获取了第一页，而reallyCurpage指向的仍然是0页，这种情况下需要将页面置为1
                [self paginationPlus];
            }
            [dict setObject:[NSString stringWithFormat:@"%d", self.reallyCurpage + 1] forKey:((NSString*)curPageName)];
            if (self.isTimestampEnable) {
                [dict setObject:[NSString stringWithFormat:@"%lld", self.timestamp] forKey:((NSString*)timestampName)];
            }
        }else if(self.paginationType == WeAppPaginationTypeId){
            [dict setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:((NSString*)pageSizeName)];
            [dict setObject:[NSString stringWithFormat:@"%d", self.reallyCurpage + 1] forKey:((NSString*)curPageName)];
            [dict setObject:[NSString stringWithFormat:@"%lld", self.id] forKey:((NSString*)idStampName)];
        }else if(self.paginationType == WeAppPaginationTypeALL){
            //加入普通翻页逻辑
            [dict setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:((NSString*)pageSizeName)];
            if (self.isTimestampEnable && self.reallyCurpage == 0) {
                [self paginationPlus];
            }
            [dict setObject:[NSString stringWithFormat:@"%d", self.reallyCurpage + 1] forKey:((NSString*)curPageName)];
            if (self.isTimestampEnable) {
                [dict setObject:[NSString stringWithFormat:@"%lld", self.timestamp] forKey:((NSString*)timestampName)];
            }
            //加入id
            [dict setObject:[NSString stringWithFormat:@"%lld", self.id] forKey:((NSString*)idStampName)];
            //加入时间戳
            if (self.beforTimestamp > 0) {
                [dict setObject:[NSString stringWithFormat:@"%lld", self.beforTimestamp] forKey:((NSString*)timestampName)];
            }else{
                [dict setObject:[NSString stringWithFormat:@"%lld", self.afterTimestamp] forKey:((NSString*)timestampName)];
            }
            [dict setObject:[NSString stringWithFormat:@"%d", self.direction] forKey:((NSString*)directionName)];
            
        }else{
            if (self.beforTimestamp > 0) {
                [dict setObject:[NSString stringWithFormat:@"%lld", self.beforTimestamp] forKey:((NSString*)timestampName)];
            }else{
                [dict setObject:[NSString stringWithFormat:@"%lld", self.afterTimestamp] forKey:((NSString*)timestampName)];
            }
            [dict setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:((NSString*)pageSizeName)];
            [dict setObject:[NSString stringWithFormat:@"%d", self.direction] forKey:((NSString*)directionName)];
            
        }
    }
}

@end
