//
//  HSSubscribedBussinessView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSSubscribedBussinessView.h"
#import "HSSubscribedBussinessViewCell.h"
#import "HSSubscribeBussinessCellModelInfoItem.h"
#import "HSSubscribedBussinessBasicModel.h"

@interface HSSubscribedBussinessView()

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@end

@implementation HSSubscribedBussinessView

-(void)setupView{
    [super setupView];
    [self addSubview:self.tableViewCtl.scrollView];
    [self refreshDataRequest];
}

-(void)refreshDataRequest{
    [self.subscribedBussinessListService refreshDataRequest];
     /*
      NSArray* array = @[@{@"subscribedBussinessStartTime":@"2015-10-19 12:29:00",@"subscribedBussinessEndTime":@"2015-10-19 12:29:00",@"subscribedBussinessDetailText":@"尊敬的用户：截止10月1日09点，您本月使用的国内上网数据流量为43M427K，剩余可用256M597K。"},
                        @{@"subscribedBussinessStartTime":@"2015-10-19 12:29:00",@"subscribedBussinessEndTime":@"2015-10-19 12:29:00",@"subscribedBussinessDetailText":@"尊敬的用户：截止10月1日09点，您本月使用的国内上网数据流量为43M427K，剩余可用256M597K。"},
                        @{@"messageTime":@"2015-10-19 13:35:00",@"subscribedBussinessDetailText":@"尊敬的用户：截止10月1日09点，您本月使用的国内上网数据流量为43M427K，剩余可用256M597K。"},
                        @{@"subscribedBussinessStartTime":@"2015-10-19 12:29:00",@"subscribedBussinessEndTime":@"2015-10-19 12:29:00",@"subscribedBussinessDetailText":@"尊敬的用户：截止10月1日09点，您本月使用的国内上网数据流量为43M427K，剩余可用256M597K。"},
                        @{@"subscribedBussinessStartTime":@"2015-10-19 12:29:00",@"subscribedBussinessEndTime":@"2015-10-19 12:29:00",@"subscribedBussinessDetailText":@"尊敬的用户：截止10月1日09点，您本月使用的国内上网数据流量为43M427K，剩余可用256M597K。"}];
     NSArray* messageModels =[HSSubscribedBussinessBasicModel modelArrayWithJSON:array];
     [self.dataSourceRead setDataWithPageList:messageModels extraDataSource:nil];
      */
     
}

-(void)dealloc{
    _tableViewCtl = nil;
    _subscribedBussinessListService.delegate = nil;
    _subscribedBussinessListService = nil;
}

-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        configObject.needNextPage = NO;
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_tableViewCtl setErrorViewTitle:@"暂无信息"];
        [_tableViewCtl setNextFootViewTitle:@""];
        [_tableViewCtl registerClass:[HSSubscribedBussinessViewCell class]];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
        WEAKSELF
        _tableViewCtl.onRefreshEvent = ^(KSScrollViewServiceController* scrollViewController){
            STRONGSELF
            [strongSelf refreshDataRequest];
        };
    }
    return _tableViewCtl;
}

-(void)setSubscribedBussinessListService:(HSSubscribedBussinessBasicService *)subscribedBussinessListService{
    if (_subscribedBussinessListService != subscribedBussinessListService) {
        _subscribedBussinessListService = nil;
        _subscribedBussinessListService = subscribedBussinessListService;
        WEAKSELF
        _subscribedBussinessListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _subscribedBussinessListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            
        };
        _subscribedBussinessListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
        [_tableViewCtl setService:_subscribedBussinessListService];
    }
}

-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
        _dataSourceRead.modelInfoItemClass = [HSSubscribeBussinessCellModelInfoItem class];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
        _dataSourceWrite.modelInfoItemClass = [HSSubscribeBussinessCellModelInfoItem class];
    }
    return _dataSourceWrite;
}

@end
