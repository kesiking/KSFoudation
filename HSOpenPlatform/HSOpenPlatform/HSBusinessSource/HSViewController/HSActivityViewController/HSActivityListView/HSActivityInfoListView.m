//
//  HSActivityInfoListView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoListView.h"
#import "HSActivityInfoCellModelInfoItem.h"
#import "HSActivityInfoCell.h"
#import "HSActivityInfoPageListService.h"
#import "HSActivityInfoModel.h"

@interface HSActivityInfoListView()

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@property (nonatomic,strong) HSActivityInfoPageListService* activityInfoPageListService;

@end

@implementation HSActivityInfoListView

-(void)setupView{
    [super setupView];
    [self addSubview:self.tableViewCtl.scrollView];
    [self refreshDataRequest];
}


-(void)refreshDataRequest{
    [self refreshDataRequestWithUserPhone:[KSAuthenticationCenter userPhone]];
}

-(void)refreshDataRequestWithUserPhone:(NSString*)userPhone{
    [self.activityInfoPageListService loadActivityInfoPageListWithUserPhone:userPhone];
    [self.tableViewCtl.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _dataSourceRead = nil;
    _dataSourceWrite = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableViewCtl config method
-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_tableViewCtl setErrorViewTitle:@"暂无活动消息"];
        [_tableViewCtl setHasNoDataFootViewTitle:@"已无活动信息可同步"];
        [_tableViewCtl setNextFootViewTitle:@""];
        [_tableViewCtl registerClass:[HSActivityInfoCell class]];
        [_tableViewCtl setService:self.activityInfoPageListService];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
    }
    return _tableViewCtl;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - service method
-(HSActivityInfoPageListService *)activityInfoPageListService{
    if (_activityInfoPageListService == nil) {
        _activityInfoPageListService = [HSActivityInfoPageListService new];
        WEAKSELF
        _activityInfoPageListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _activityInfoPageListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            
        };
        _activityInfoPageListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
    }
    return _activityInfoPageListService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - list dataSource method
-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
        _dataSourceRead.modelInfoItemClass = [HSActivityInfoCellModelInfoItem class];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
        _dataSourceWrite.modelInfoItemClass = [HSActivityInfoCellModelInfoItem class];
    }
    return _dataSourceWrite;
}

@end
