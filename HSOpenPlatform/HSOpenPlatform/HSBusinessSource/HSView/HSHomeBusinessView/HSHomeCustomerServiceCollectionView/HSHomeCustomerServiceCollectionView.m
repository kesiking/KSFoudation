//
//  HSHomeCustomerServiceCollectionView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeCustomerServiceCollectionView.h"
#import "HSFamilyAppListService.h"


@interface HSHomeCustomerServiceCollectionView ()


@property (strong, nonatomic) HSFamilyAppListService *familyAppListService;


@end

@implementation HSHomeCustomerServiceCollectionView

-(void)refreshDataRequest {
    if (self.dataArray.count == 0) {
        [self.familyAppListService loadFamilyAppListDataWithBusinessId:nil];
    }
    else {
        !self.serviceDidFinishLoadBlock?:self.serviceDidFinishLoadBlock();
    }
}

- (HSFamilyAppListService *)familyAppListService {
    if (!_familyAppListService) {
        _familyAppListService = [HSFamilyAppListService new];
        
        WEAKSELF
        _familyAppListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            EHLogInfo(@"getfamilyAppList完成！");
            STRONGSELF
            EHLogInfo(@"%@",service.dataList);
//            strongSelf.dataArray = service.dataList;
            NSMutableArray *mutDataArray = [service.dataList mutableCopy];
            NSInteger column = strongSelf.width/strongSelf.cellWidth;
            NSInteger num = column - service.dataList.count % column;
            if (num %column != 0) {
                for (NSInteger i = 0; i<num; i++) {
                    HSApplicationModel *model = [[HSApplicationModel alloc]init];
                    [mutDataArray addObject:model];
                }
            }
            strongSelf.dataArray = mutDataArray;
            
            NSDictionary *nameStringDict = @{@"和路由":@"icon_和路由_80",@"和目":@"icon_和目_80",@"路尚":@"icon_路尚_80",@"咪咕":@"icon_咪咕_80",@"魔百盒":@"icon_魔百合_80",@"找他":@"icon_找他_80px",@"甘肃移动掌上营业厅":@"icon_甘肃移动-掌上营业厅_80"};
            for (NSInteger i=0; i<service.dataList.count; i++) {
                HSApplicationModel *item = strongSelf.dataArray[i];
                item.placeholderImageStr = [nameStringDict objectForKey:item.appName];
            }
            [strongSelf reloadData];
            //!strongSelf.itemIndexBlock?:strongSelf.itemIndexBlock(strongSelf.itemIndexPath);
            
            !strongSelf.serviceDidFinishLoadBlock?:strongSelf.serviceDidFinishLoadBlock();
        };
        _familyAppListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            !strongSelf.serviceDidFailLoadBlock?:strongSelf.serviceDidFailLoadBlock();
        };
    }
    return _familyAppListService;
}

-(void)setItemIndexPath:(NSIndexPath *)itemIndexPath{
    //[super setItemIndexPath:itemIndexPath];
    _itemIndexPath = itemIndexPath;
    !self.itemIndexBlock?:self.itemIndexBlock(itemIndexPath);

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
