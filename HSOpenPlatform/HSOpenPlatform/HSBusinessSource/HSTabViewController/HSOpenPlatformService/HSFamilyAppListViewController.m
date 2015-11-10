//
//  HSFamilyAppListViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/15.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSFamilyAppListViewController.h"
#import "HSFamilyAppListService.h"
#import "HSFamilyAppInfoService.h"
#import "HSCollectionItemTableViewCell.h"
#import "HSAppCollectionView.h"
#import "HSApplicationIntroModel.h"
#import "HSApplicationModel.h"
#import "HSAppListCollectionView.h"



@interface HSFamilyAppListViewController ()

{
    HSFamilyAppListService *_familyAppListService;
    //HSFamilyAppInfoService *_familyAppInfoService;
    //NSMutableArray* _functionCollectionItemList;

}


@property (strong, nonatomic) HSApplicationIntroModel *appIntro;
//@property (strong, nonatomic) HSAppCollectionView *collectionTableView;
@property (strong, nonatomic) HSAppListCollectionView *collectionView;
@property (strong, nonatomic) HSFamilyAppInfoService *familyAppInfoService;
@property (assign, nonatomic) BOOL isAppInstalled;
@property (strong, nonatomic) NSArray *nameStringArr;


@end

@implementation HSFamilyAppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configGetFamilyAppList];
    [self configGetFamilyAppIntro];
    
//    [self.view addSubview:self.collectionTableView];
    [self.view addSubview:self.collectionView];
    self.nameStringArr = @[@"icon_lushang",@"icon_heluyou",@"icon_hemu",@"icon_zhaota",@"icon_mobaihe",@"icon_migu"];
    
    
}

- (void)configGetFamilyAppList
{
    _familyAppListService = [HSFamilyAppListService new];
    
    WEAKSELF
    _familyAppListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getfamilyAppList完成！");
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
//        strongSelf.collectionTableView.dataArray = service.dataList;
//        for (NSInteger i=0; i<strongSelf.collectionTableView.dataArray.count; i++) {
//            HSApplicationModel *item = service.dataList[i];
//            item.placeholderImageStr = strongSelf.nameStringArr[i];
//        }
//        [strongSelf.collectionTableView reloadData];
        strongSelf.collectionView.dataArray = service.dataList;
        for (NSInteger i=0; i<strongSelf.collectionView.dataArray.count; i++) {
        HSApplicationModel *item = service.dataList[i];
        item.placeholderImageStr = strongSelf.nameStringArr[i];
        }
        [strongSelf.collectionView reloadData];
        
    };
    _familyAppListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取失败"];
    };
    
    [_familyAppListService loadFamilyAppListData];

}

- (void)configGetFamilyAppIntro
{
    _familyAppInfoService = [HSFamilyAppInfoService new];
    
    WEAKSELF
    _familyAppInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getFamilyAppIntro完成！");
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
        strongSelf.appIntro = (HSApplicationIntroModel *)service.item;
        NSLog(@"strongSelf.appIntro.appDetailIos = %@",strongSelf.appIntro.appDetailIos.appIOSURLScheme);
        NSURL *appURLScheme = [NSURL URLWithString:strongSelf.appIntro.appDetailIos.appIOSURLScheme];
        BOOL isAppInstalled = [[UIApplication sharedApplication] canOpenURL:appURLScheme];
        if (isAppInstalled) {
            [[UIApplication sharedApplication] openURL:appURLScheme];
        }
        else{
        TBOpenURLFromSourceAndParams(internalURL(@"HSFamilyAppIntroViewController"), strongSelf,@{WEB_REQUEST_URL_ADDRESS_KEY:strongSelf.appIntro.appExtUrl,WEB_VIEW_TITLE_KEY:strongSelf.appIntro.appName,});
            //@"isAppInstalled":[[NSNumber alloc]initWithBool:strongSelf.isAppInstalled]
                                     
        }
    };
    _familyAppInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取FamilyAppInfo失败"];
    };
}


#pragma mark - setter and getter

-(HSAppListCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3,150*SCREEN_SCALE);
//        flowLayout.sectionInset = UIEdgeInsetsZero;
//        flowLayout.minimumInteritemSpacing = 0.;
//        flowLayout.minimumLineSpacing = 0.;
        _collectionView = [[HSAppListCollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        WEAKSELF
        _collectionView.appIndexBlock = ^(NSInteger appIndex){
            STRONGSELF
            HSApplicationModel *appModel = strongSelf.collectionView.dataArray[appIndex];
            [strongSelf configGetFamilyAppIntro];
            [strongSelf.familyAppInfoService loadFamilyAppInfoWithAppId:appModel.appId];
        };
        return _collectionView;
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
