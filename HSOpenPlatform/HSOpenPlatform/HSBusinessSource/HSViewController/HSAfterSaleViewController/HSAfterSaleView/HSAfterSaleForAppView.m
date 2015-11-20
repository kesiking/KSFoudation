//
//  HSAfterSaleForAppView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleForAppView.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSNationalAfterSaleService.h"
#import "HSLocalAfterSaleService.h"

#define kHSAfterSaleViewHeaderHeight    caculateNumber(31.0)
#define kHLocalAfterSaleCellHeight      caculateNumber(105)

@interface HSAfterSaleForAppView ()

@property (nonatomic, strong) HSNationalAfterSaleService *nationalAfterSaleService;

@property (nonatomic, strong) HSLocalAfterSaleService *localAfterSaleService;

@property (nonatomic, strong) NSDictionary *imageStrDictionary;

@property (nonatomic, assign) BOOL isNationalAfterSaleNeedReload;

@end

@implementation HSAfterSaleForAppView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.isNationalAfterSaleNeedReload = YES;
    }
    return self;
}

- (void)refreshDataWithAppModel:(HSApplicationModel*)appModel {
    self.appModel = appModel;
    self.isNationalAfterSaleNeedReload = YES;
    [self refreshData];
}

#pragma mark - Config refreshData & loadMoreData
/**
 *  下拉刷新
 */
- (void)refreshData {
    
    if (self.needRefreshBlock) {
        BOOL needRefreshData = self.needRefreshBlock();
        if (!needRefreshData) {
            return;
        }
    }
    if (!self.appModel) {
        EHLogError(@"appModel = nil!");
        [self reloadFail];
        return;
    }

    self.currentPage = 1;

    if (self.isNationalAfterSaleNeedReload) {
        [self.nationalAfterSaleService getNationalAfterSaleWithAppId:self.appModel.appId];
    }
    
    [self.localAfterSaleService getLocalAfterSaleWithAppId:self.appModel.appId PageSize:self.offset CurrentPage:self.currentPage];
}

/**
 *  上拉加载
 */
- (void)loadMoreData {
    self.currentPage++;
    [self.localAfterSaleService getLocalAfterSaleWithAppId:self.appModel.appId PageSize:self.offset CurrentPage:self.currentPage];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:self.dataArray forKey:@"poiList"];
        [params setObject:@(indexPath.row) forKey:@"selectedIndex"];
        TBOpenURLFromSourceAndParams(internalURL(@"HSBusinessHallMapViewController"), self, params);
    }
}


#pragma mark - Config Services
- (HSNationalAfterSaleService *)nationalAfterSaleService {
    if (!_nationalAfterSaleService) {
        _nationalAfterSaleService = [HSNationalAfterSaleService new];
        WEAKSELF
        _nationalAfterSaleService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
            STRONGSELF
            strongSelf.nationalAfterSaleModel = (HSNationalAfterSaleModel *)service.item;
            strongSelf.nationalAfterSaleModel.appIconUrl = strongSelf.appModel.appIconUrl;
            strongSelf.nationalAfterSaleModel.placeholderImageStr = [strongSelf.imageStrDictionary objectForKey:strongSelf.appModel.appName];
            strongSelf.isNationalAfterSaleNeedReload = NO;
            
            NSIndexSet * indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [strongSelf reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        };
        _nationalAfterSaleService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            strongSelf.isNationalAfterSaleNeedReload = YES;
        };
    }
    return _nationalAfterSaleService;
}

- (HSLocalAfterSaleService *)localAfterSaleService {
    if (!_localAfterSaleService) {
        _localAfterSaleService = [HSLocalAfterSaleService new];
        WEAKSELF
        _localAfterSaleService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
            STRONGSELF
            if (strongSelf.currentPage == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            for (HSLocalAfterSaleModel *localAfterSaleModel in service.dataList) {
                HSMapPoiModel *poiModel = [[HSMapPoiModel alloc]initWithLocalAfterSaleModel:localAfterSaleModel];
                [strongSelf.dataArray addObject:poiModel];
            }
            [strongSelf reloadData];
        };
        _localAfterSaleService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf reloadFail];
        };
    }
    return _localAfterSaleService;
}

- (NSDictionary *)imageStrDictionary {
    if (!_imageStrDictionary) {
        _imageStrDictionary = @{@"路尚":@"icon_heluyou",@"和目":@"icon_hemu",@"路尚":@"icon_lushang",@"咪咕":@"icon_migu",@"魔百盒":@"icon_mobaihe",@"找它":@"icon_zhaota",};
    }
    return _imageStrDictionary;
}

@end
