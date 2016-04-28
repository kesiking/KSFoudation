//
//  HSAfterSaleForAppView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleForAppView.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSAfterSaleListService.h"

#define kHSAfterSaleViewHeaderHeight    caculateNumber(31.0)
#define kHLocalAfterSaleCellHeight      caculateNumber(105)

@interface HSAfterSaleForAppView ()

@property (nonatomic, strong) HSAfterSaleListService *afterSaleListService;

@property (nonatomic, strong) HSProductInfoModel *productModel;

@property (nonatomic, strong) NSDictionary *imageStrDictionary;

@end

@implementation HSAfterSaleForAppView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}

- (void)refreshDataWithProductModel:(HSProductInfoModel*)productModel {
    self.productModel = productModel;
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
    if (!self.productModel) {
        EHLogError(@"productModel = nil!");
        [self reloadFail];
        return;

    }
    self.currentPage = 1;
    [self.afterSaleListService getAfterSaleListWithProductId:self.productModel.productId PageSize:self.offset CurrentPage:self.currentPage];
}

/**
 *  上拉加载
 */
- (void)loadMoreData {
    self.currentPage++;
    [self.afterSaleListService getAfterSaleListWithProductId:self.productModel.productId PageSize:self.offset CurrentPage:self.currentPage];
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
- (HSAfterSaleListService *)afterSaleListService {
    if (!_afterSaleListService) {
        _afterSaleListService = [HSAfterSaleListService new];
        WEAKSELF
        _afterSaleListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
            STRONGSELF
            if (strongSelf.currentPage == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            if (service.dataList.count == 0) {
                strongSelf.nationalAfterSaleModel = nil;
            }
            //第一个为全国售后，将剩下的本地售后提取加入数据源
            for (NSUInteger i = 0; i < service.dataList.count; i++) {
                HSAfterSaleModel *afterSaleModel = service.dataList[i];
                if (i == 0 && strongSelf.currentPage == 1) {
                    strongSelf.nationalAfterSaleModel = afterSaleModel;
                    strongSelf.nationalAfterSaleModel.productIconUrl = strongSelf.productModel.productLogo;
                    strongSelf.nationalAfterSaleModel.placeholderImageStr = [strongSelf.imageStrDictionary objectForKey:strongSelf.productModel.productName];
                }
                else {
                    HSMapPoiModel *poiModel = [[HSMapPoiModel alloc]initWithAfterSaleModel:afterSaleModel];
                    [strongSelf.dataArray addObject:poiModel];
                }
            }
            
            [strongSelf reloadData];
            [strongSelf updateFooterStateAfterRefreshing];
        };
        _afterSaleListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf reloadFail];
        };
    }
    return _afterSaleListService;
}

- (NSDictionary *)imageStrDictionary {
    if (!_imageStrDictionary) {
        _imageStrDictionary = @{@"路尚":@"icon_heluyou",@"和目":@"icon_hemu",@"路尚":@"icon_lushang",@"咪咕":@"icon_migu",@"魔百盒":@"icon_mobaihe",@"找它":@"icon_zhaota",};
    }
    return _imageStrDictionary;
}

@end
