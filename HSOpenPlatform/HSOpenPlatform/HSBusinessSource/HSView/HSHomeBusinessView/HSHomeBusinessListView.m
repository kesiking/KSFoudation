//
//  HSHomeBusinessListView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeBusinessListView.h"
#import "HSFamilyAppListService.h"
#import "HSFamilyAppInfoService.h"
#import "HSApplicationIntroModel.h"
#import "HSApplicationModel.h"
#import "HSProductListService.h"
#import "HSProductInfoService.h"

@interface HSHomeBusinessListView ()

@property (strong, nonatomic) HSProductListService *productListService;

@property (nonatomic, strong) NSDictionary *imageStrDictionary;

@end

@implementation HSHomeBusinessListView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellClass:(Class)cellClass {
    self = [super initWithFrame:frame collectionViewLayout:layout cellClass:cellClass];
    if (self) {
        self.backgroundColor = RGB(235, 235, 241);
        WEAKSELF
        self.itemIndexBlock = ^(NSIndexPath *itemIndexPath) {
            [weakSelf openUrlAtIndexPath:itemIndexPath];
        };
    }
    return self;
}

-(void)refreshDataRequest {
    [self.productListService loadProductListWithBusinessId:0];
}

- (void)openUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSProductInfoModel *productInfo = (HSProductInfoModel *)self.dataArray[indexPath.row];
        TBOpenURLFromSourceAndParams(@"HSProductInfoViewController", self, @{@"productInfo":productInfo});
}

#pragma mark - Getters
- (HSProductListService *)productListService {
    if (!_productListService) {
        _productListService = [HSProductListService new];
        WEAKSELF
        _productListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            NSLog(@"HSProductListService service.dataList = %@",service.dataList);
            STRONGSELF
            strongSelf.dataArray = service.dataList;
            for (NSInteger i=0; i<strongSelf.dataArray.count; i++) {
                HSProductInfoModel *item = service.dataList[i];
                item.placeholderImageStr = [strongSelf.imageStrDictionary objectForKey:item.productName];
            }
            
            strongSelf.height = (strongSelf.dataArray.count == 0)?0:strongSelf.dataArray.count * (strongSelf.cellHeight + home_business_minimumLineSpacing) - home_business_minimumLineSpacing;
            
            [strongSelf reloadData];
            !strongSelf.serviceDidFinishLoadBlock?:strongSelf.serviceDidFinishLoadBlock();
        };
        _productListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"获取失败"];
        };
    }
    return _productListService;
}

- (NSDictionary *)imageStrDictionary {
    if (!_imageStrDictionary) {
        _imageStrDictionary = @{@"和路由":@"banner_heluyou",@"和目":@"banner_hemu",@"路尚":@"banner_lushang",@"咪咕":@"banner_migu",@"魔百盒":@"banner_mobaihe",@"找它":@"banner_zhaota",};
    }
    return _imageStrDictionary;
}


@end