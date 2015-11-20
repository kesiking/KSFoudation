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
        [self.familyAppListService loadFamilyAppListData];

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
            strongSelf.dataArray = service.dataList;
            NSArray *nameStringArr = @[@"icon_lushang",@"icon_heluyou",@"icon_hemu",@"icon_zhaota",@"icon_mobaihe",@"icon_migu"];
            for (NSInteger i=0; i<strongSelf.dataArray.count; i++) {
                HSApplicationModel *item = service.dataList[i];
                item.placeholderImageStr = nameStringArr[i];
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
