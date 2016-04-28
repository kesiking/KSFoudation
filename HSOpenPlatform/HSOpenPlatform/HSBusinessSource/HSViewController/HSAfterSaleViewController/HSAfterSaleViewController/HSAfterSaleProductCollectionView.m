//
//  HSAfterSaleProductCollectionView.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/31.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSAfterSaleProductCollectionView.h"
#import "HSProductListService.h"

@interface HSAfterSaleProductCollectionView ()

@property (nonatomic, strong) HSProductListService *productListService;

@property (nonatomic, strong) NSDictionary *iconNameDictionary;

@end

@implementation HSAfterSaleProductCollectionView

-(void)refreshDataRequest {
    if (self.dataArray.count == 0) {
        [self.productListService loadProductListWithBusinessId:0];
    }
    else {
        !self.serviceDidFinishLoadBlock?:self.serviceDidFinishLoadBlock();
    }
}

- (HSProductListService *)productListService {
    if (!_productListService) {
        _productListService = [HSProductListService new];
        
        WEAKSELF
        _productListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            EHLogInfo(@"_productListService完成！");
            STRONGSELF
            EHLogInfo(@"%@",service.dataList);
            strongSelf.dataArray = service.dataList;
            
            for (NSInteger i=0; i<service.dataList.count; i++) {
                HSProductInfoModel *model = strongSelf.dataArray[i];
                model.placeholderImageStr = strongSelf.iconNameDictionary[model.productName];
            }
            [strongSelf reloadData];
            !strongSelf.serviceDidFinishLoadBlock?:strongSelf.serviceDidFinishLoadBlock();
        };
        _productListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            !strongSelf.serviceDidFailLoadBlock?:strongSelf.serviceDidFailLoadBlock();
        };
    }
    return _productListService;
}

-(void)setItemIndexPath:(NSIndexPath *)itemIndexPath{
    !self.itemDeselectBlock?:self.itemDeselectBlock(_itemIndexPath);
    
    _itemIndexPath = itemIndexPath;
    !self.itemIndexBlock?:self.itemIndexBlock(itemIndexPath);
}

- (NSDictionary *)iconNameDictionary {
    if (!_iconNameDictionary) {
        _iconNameDictionary = @{@"和路由":@"icon_和路由_80",
                                @"和目":@"icon_和目_80",
                                @"路尚":@"icon_路尚_80",
                                @"咪咕":@"icon_咪咕_80",
                                @"魔百盒":@"icon_魔百合_80",
                                @"找他":@"icon_找他_80px",
                                @"甘肃移动-掌上营业":@"icon_甘肃移动-掌上营业厅_80",
                                };
    }
    return _iconNameDictionary;
}

@end
