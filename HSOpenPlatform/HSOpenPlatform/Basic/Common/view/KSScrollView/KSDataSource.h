//
//  KSDataSource.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSCellModelInfoItem;

@interface KSDataSource : NSObject{
    NSArray                          *_dataList;
    NSMutableDictionary              *_modelList;
}

@property (nonatomic, strong) Class                modelInfoItemClass;

// 用pageList初始化dataSource
-(void)setDataWithPageList:(NSArray *)pageList extraDataSource:(NSDictionary*)extraInfoParams;

// 根据index获取componentItem，而后配置初始化modelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupComponentItemWithIndex:(NSUInteger)index;

// 在dataList中，获取componentItem
-(WeAppComponentBaseItem*)getComponentItemWithIndex:(NSUInteger)index;

-(NSInteger)count;

-(void)removeAllCellitems;

-(void)deleteItemAtIndexs:(NSIndexSet*)indexs;

// 获取KSCellModelInfoItem，在modelInfoItem中可以获取cell需要的参数
-(KSCellModelInfoItem*)getComponentModelInfoItemWithIndex:(NSUInteger)index;

-(BOOL)getImageDidLoadedWithIndex:(NSUInteger)index;

-(void)setImageDidLoaded:(BOOL)imageLoaded atIndex:(NSUInteger)index;

-(NSArray*)getDataList;

@end

@interface KSCellModelInfoItem : NSObject

@property (nonatomic, weak)   KSDataSource*      dataSource;

@property (nonatomic, strong) NSString*          modelInfoItemId;

@property (nonatomic, assign) CGRect             frame;

@property (nonatomic, assign) BOOL               imageHasLoaded;

// 原则上与[cellIndexPath row]相同
@property (nonatomic, assign) NSUInteger         cellIndex;

// 可包含section信息，未来可扩展
@property (nonatomic, assign) NSIndexPath*       cellIndexPath;

// 存储了配置信息
@property (nonatomic, strong) id                 configObject;

// 预留
@property (nonatomic, strong) NSDictionary*      modelInfoDict;

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
// 根据componentItem计算高度或是存储需要的数据，用于优化性能
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem;

@end
