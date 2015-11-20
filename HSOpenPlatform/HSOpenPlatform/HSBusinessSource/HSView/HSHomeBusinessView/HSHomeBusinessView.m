//
//  HSHomeBusinessView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeBusinessView.h"
#import "HSFamilyAppListService.h"
#import "HSFamilyAppInfoService.h"
#import "HSApplicationIntroModel.h"
#import "HSApplicationModel.h"

@interface HSHomeBusinessView ()

@property (nonatomic, strong)HSHomeBusinessListView *collectionView;

@property (nonatomic, strong)UIView *errorView;

@property (strong, nonatomic) HSFamilyAppListService *familyAppListService;

@property (strong, nonatomic) HSFamilyAppInfoService *familyAppInfoService;

@property (nonatomic, strong) NSDictionary *imageStrDictionary;

@end

@implementation HSHomeBusinessView

- (void)setupView {
    [self addSubview:self.collectionView];
    
    [self configGetFamilyAppList];
    [self configGetFamilyAppIntro];
}

-(void)refreshDataRequest {
    [self.familyAppListService loadFamilyAppListData];
}

- (void)configGetFamilyAppList
{
    _familyAppListService = [HSFamilyAppListService new];
    
    WEAKSELF
    _familyAppListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF        
        strongSelf.collectionView.dataArray = service.dataList;
        for (NSInteger i=0; i<strongSelf.collectionView.dataArray.count; i++) {
            HSApplicationModel *item = service.dataList[i];
            item.placeholderImageStr = [strongSelf.imageStrDictionary objectForKey:item.appName];
        }
        strongSelf.collectionView.height = (service.dataList.count + 1) / 2 * home_businessListCell_height;
        strongSelf.height = strongSelf.collectionView.height;
        [strongSelf.collectionView reloadData];
        !strongSelf.resetFrameBlock?:strongSelf.resetFrameBlock();
        
    };
    _familyAppListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"获取失败"];
    };
    
    [_familyAppListService loadFamilyAppListData];
}

- (void)configGetFamilyAppIntro
{
    _familyAppInfoService = [HSFamilyAppInfoService new];
    
    WEAKSELF
    _familyAppInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        HSApplicationIntroModel *appIntro = (HSApplicationIntroModel *)service.item;
        NSURL *appURLScheme = [NSURL URLWithString:appIntro.appDetailIos.appIOSURLScheme];
        BOOL isAppInstalled = [[UIApplication sharedApplication] canOpenURL:appURLScheme];
        TBOpenURLFromSourceAndParams(internalURL(@"HSFamilyAppIntroViewController"), strongSelf,@{WEB_REQUEST_URL_ADDRESS_KEY:appIntro.appExtUrl,WEB_VIEW_TITLE_KEY:appIntro.appName,@"isAppInstalled":@(isAppInstalled),appIntro.appDetailIos.appIOSURLScheme:@"appIOSURLScheme"});
    };
    _familyAppInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取FamilyAppInfo失败"];
    };
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[HSHomeBusinessListView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        WEAKSELF
        _collectionView.appSelectedBlock = ^(NSInteger selectedIndex) {
            STRONGSELF
            HSApplicationModel *appModel = strongSelf.collectionView.dataArray[selectedIndex];
            TBOpenURLFromSourceAndParams(internalURL(@"HSAfterSaleForAppViewController"), strongSelf, @{@"appModel":appModel});
            return ;
            [strongSelf configGetFamilyAppIntro];
            [strongSelf.familyAppInfoService loadFamilyAppInfoWithAppId:appModel.appId];
        };
    }
    return _collectionView;
}


- (NSDictionary *)imageStrDictionary {
    if (!_imageStrDictionary) {
        _imageStrDictionary = @{@"路尚":@"icon_heluyou",@"和目":@"icon_hemu",@"路尚":@"icon_lushang",@"咪咕":@"icon_migu",@"魔百盒":@"icon_mobaihe",@"找它":@"icon_zhaota",};
    }
    return _imageStrDictionary;
}

@end
