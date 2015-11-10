//
//  KSDataSource.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSDataSource.h"
#import "WeAppBasicPagedList.h"

@interface KSDataSource ()

@property (nonatomic, strong) NSArray             *dataList;  //存储pagelist数据
@property (nonatomic, strong) NSMutableDictionary *modelList; //存储cell高度

@end

@implementation KSDataSource

@synthesize dataList = _dataList;
@synthesize modelList = _modelList;

-(id)init{
    if (self = [super init]) {
        [self configList];
    }
    return self;
}

-(void)configList{
    if (_modelList == nil) {
        _modelList = [[NSMutableDictionary alloc] init];
    }
}

-(void)setModelInfoItemClass:(Class)modelInfoItemClass{
    _modelInfoItemClass = modelInfoItemClass;
}

-(void)configWithPageList:(NSArray*)pageList{
    if (pageList && [pageList isKindOfClass:[NSArray class]]) {
        _dataList = pageList;
    }else{
        _dataList = nil;
    }
}

-(void)setDataWithPageList:(NSArray *)pageList extraDataSource:(NSDictionary*)extraInfoParams{
    [self configList];
    if (pageList) {
        [self configWithPageList:pageList];
    }
}

-(WeAppComponentBaseItem *)getComponentItemWithIndex:(NSUInteger)index{
    if (self.dataList == nil
        || index >= [self.dataList count]) {
        return nil;
    }
    WeAppComponentBaseItem* componentItem = [self.dataList objectAtIndex:index];
    if (componentItem == nil) {
        return nil;
    }
    if ([componentItem isKindOfClass:[NSDictionary class]]) {
        return [[WeAppComponentBaseItem alloc] initWithDictionary:(NSDictionary*)componentItem];
    }
    if (![componentItem isKindOfClass:[WeAppComponentBaseItem class]]) {
        return nil;
    }
    return componentItem;
}

-(NSInteger)count{
    if (_dataList) {
        return _dataList.count;
    }
    return 0;
}

-(NSArray*)getDataList{
    return _dataList;
}

-(void)removeAllCellitems{
    if (_modelList) {
        [_modelList removeAllObjects];
    }
}

-(void)deleteItemAtIndexs:(NSIndexSet*)indexs{
    if (indexs == nil
        || ![indexs isKindOfClass:[NSIndexSet class]]
        || [indexs count] <= 0) {
        return;
    }
    @try {
        __block BOOL isArrayIndexOverBoundary = NO;
        [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            if (idx >= [self.dataList count]) {
                *stop = YES;
                isArrayIndexOverBoundary = YES;
            }else{
                WeAppComponentBaseItem* componentItem = [self getComponentItemWithIndex:idx];
                NSString* modelInfoItemId = [self getModelInfoItemIdWithComponentItem:componentItem atIndex:idx];
                if (_modelList && [_modelList count] > 0 && modelInfoItemId) {
                    [_modelList removeObjectForKey:modelInfoItemId];
                }
            }
        }];
        if (!isArrayIndexOverBoundary) {
            NSMutableArray* dataList = [_dataList mutableCopy];
            [dataList removeObjectsAtIndexes:indexs];
            _dataList = dataList;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"-------> KSDataSource %s crashed for %@",__FUNCTION__,exception.reason);
    }
    
}

// 根据index获取componentItem，而后配置初始化modelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupComponentItemWithIndex:(NSUInteger)index{
    
    WeAppComponentBaseItem* componentItem = [self getComponentItemWithIndex:index];
    
    NSString* modelInfoItemId = [self getModelInfoItemIdWithComponentItem:componentItem atIndex:index];
    
    //如果模板已经存在就不需要再重新生成模板，提升性能
    @synchronized(_modelList){
        if (_modelList && [_modelList count] > 0 && modelInfoItemId) {
            KSCellModelInfoItem* modelInfoItem = [_modelList objectForKey:modelInfoItemId];
            if (modelInfoItem) {
                return;
            }
        }
    }
    
    [self setupComponentModelInfoItemWithComponentItem:componentItem withModelInfoItemId:modelInfoItemId atIndex:index];
}

-(KSCellModelInfoItem*)getComponentModelInfoItemWithIndex:(NSUInteger)index{
    
    WeAppComponentBaseItem* componentItem = [self getComponentItemWithIndex:index];
    
    NSString* modelInfoItemId = [self getModelInfoItemIdWithComponentItem:componentItem atIndex:index];
    
    if (_modelList && [_modelList count] > 0 && modelInfoItemId) {
        KSCellModelInfoItem* modelInfoItem = [_modelList objectForKey:modelInfoItemId];
        if (modelInfoItem) {
            return modelInfoItem;
        }
    }
    
    return [self setupComponentModelInfoItemWithComponentItem:componentItem withModelInfoItemId:modelInfoItemId atIndex:index];
}

-(NSString*)getModelInfoItemIdWithComponentItem:(WeAppComponentBaseItem*)componentItem atIndex:(NSUInteger)index{
    NSMutableString* modelInfoItemId = [NSMutableString string];
    if (componentItem) {
        NSNumber* reuseIdentifier = [NSNumber numberWithUnsignedInteger:[componentItem hash]];
        if (reuseIdentifier) {
            [modelInfoItemId appendFormat:@"%@",reuseIdentifier];
        }
    }
    //根据index制作每个cell自己的viewId
    [modelInfoItemId appendFormat:@"_%lu",(unsigned long)index];
    return modelInfoItemId;
}

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(KSCellModelInfoItem*)setupComponentModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem withModelInfoItemId:(NSString*)modelInfoItemId atIndex:(NSUInteger)index {
    
    KSCellModelInfoItem* modelInfoItem = nil;
    
    if (self.modelInfoItemClass && [self.modelInfoItemClass isSubclassOfClass:[KSCellModelInfoItem class]]) {
        modelInfoItem = [[self.modelInfoItemClass alloc] init];
    }else{
        modelInfoItem = [[KSCellModelInfoItem alloc] init];
    }
    
    modelInfoItem.modelInfoItemId = modelInfoItemId;
    modelInfoItem.cellIndex = index;
    modelInfoItem.dataSource = self;
    [modelInfoItem setupCellModelInfoItemWithComponentItem:componentItem];
    
    @synchronized(_modelList){
        if (_modelList && modelInfoItemId && modelInfoItem) {
            [_modelList setObject:modelInfoItem forKey:modelInfoItemId];
        }
    }
    
    return modelInfoItem;
}

//image 刷新逻辑优化
-(BOOL)getImageDidLoadedWithIndex:(NSUInteger)index{
    KSCellModelInfoItem* modelInfoItem = [self getComponentModelInfoItemWithIndex:index];
    if (modelInfoItem == nil || modelInfoItem.modelInfoItemId == nil || modelInfoItem.modelInfoItemId.length <= 0) {
        return NO;
    }
    //如果cell的images已经下载过返回YES，否则返回NO
    return modelInfoItem.imageHasLoaded;
}

-(void)setImageDidLoaded:(BOOL)imageLoaded atIndex:(NSUInteger)index{
    KSCellModelInfoItem* modelInfoItem = [self getComponentModelInfoItemWithIndex:index];
    if (modelInfoItem == nil || modelInfoItem.modelInfoItemId == nil || modelInfoItem.modelInfoItemId.length <= 0) {
        return;
    }
    //如果cell的images已经下载过返回YES，否则返回NO
    modelInfoItem.imageHasLoaded = imageLoaded;
}

@end

@implementation KSCellModelInfoItem

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem{
    
}

@end
