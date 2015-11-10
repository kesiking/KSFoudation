//
//  KSPageList.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/5/23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "WeAppBasicPagedList.h"

typedef enum {
    KSInsertListTypeBeforPagelist = 0,     //0--- 在pagelist前插入
    KSInsertListTypeAfterPagelist = 1,     //1--- 在pagelist后插入
    KSInsertListTypeBetweenPagelist = 2,   //2--- 在pagelist中间插入

}KSInsertListType;

@interface KSPageList : WeAppBasicPagedList

@property(nonatomic, strong) NSArray        *insertDataList;

@property(nonatomic, strong) NSArray        *deleteDataList;

@property(nonatomic, assign) KSInsertListType   insertListType;

-(void)noDataPageListlogic;

@end
