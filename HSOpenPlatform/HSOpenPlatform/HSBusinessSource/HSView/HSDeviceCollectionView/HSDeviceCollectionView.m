//
//  HSDeviceCollectionView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/28.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSDeviceCollectionView.h"
#import "HSDeviceListService.h"
#import "HSProductListService.h"
#import "HSDeviceModel.h"

@interface HSDeviceCollectionView ()

@property (strong, nonatomic) HSDeviceListService *deviceListService;

//@property (strong, nonatomic) HSProductListService *productListService;

//@property (strong, nonatomic) NSArray *productLogoArray;

@end

@implementation HSDeviceCollectionView

-(void)refreshDataRequest {
    if (self.dataArray.count == 0) {
        [self.deviceListService loadUserDeviceListWithUserPhone:[KSAuthenticationCenter userPhone] productId:@""];
    }
    else {
        !self.serviceDidFinishLoadBlock?:self.serviceDidFinishLoadBlock();
    }
}


- (HSDeviceListService *)deviceListService {
    if (!_deviceListService) {
        _deviceListService = [HSDeviceListService new];
        WEAKSELF
        _deviceListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            
            strongSelf.dataArray = service.dataList;
            
            NSDictionary *nameStringDict = @{@"和路由":@"icon_和路由_60",@"和目":@"icon_和目_60",@"路尚":@"icon_路尚_60",@"咪咕":@"icon_咪咕_60",@"魔百盒":@"icon_魔百和_60",@"找他":@"icon_找他_60px",@"甘肃移动掌上营业厅":@"icon_甘肃移动-掌上营业厅_60"};
            for (NSInteger i=0; i<service.dataList.count; i++) {
                HSDeviceModel *item = strongSelf.dataArray[i];
                item.placeholderImageStr = [nameStringDict objectForKey:item.productName];
            }
            
            [strongSelf reloadData];
            
            !strongSelf.serviceDidFinishLoadBlock?:strongSelf.serviceDidFinishLoadBlock();
            
        };
        
        _deviceListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            !strongSelf.serviceDidFailLoadBlock?:strongSelf.serviceDidFailLoadBlock();
            
        };

    
    }
    
    return _deviceListService;
}

//- (HSProductListService *)productListService{
//    if (!_productListService) {
//        _productListService = [HSProductListService new];
//        
//    }
//}


    
    





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
