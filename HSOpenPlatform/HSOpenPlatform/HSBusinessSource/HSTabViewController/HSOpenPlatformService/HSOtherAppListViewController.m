//
//  HSOtherAppListViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/15.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSOtherAppListViewController.h"
#import "HSOtherAppListService.h"
#import "HSOtherAppInfoService.h"
#import "HSAppCollectionView.h"
#import "HSApplicationIntroModel.h"
#import "HSCollectionItemTableViewCell.h"
#import "HSAppListCollectionView.h"




@interface HSOtherAppListViewController ()
{
    HSOtherAppListService *_otherAppListService;
    //HSOtherAppInfoService *_otherAppInfoService;
}

@property (strong, nonatomic) HSApplicationIntroModel *appIntro;
//@property (strong, nonatomic) HSAppCollectionView *collectionTableView;
@property (strong, nonatomic) HSAppListCollectionView *collectionView;

@property (strong, nonatomic) HSOtherAppInfoService *otherAppInfoService;


@end

@implementation HSOtherAppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configGetOtherAppList];
    //[self configGetOtherAppIntro];
    [self.view addSubview:self.collectionView];
    
}

- (void)configGetOtherAppList
{
    _otherAppListService = [HSOtherAppListService new];
    
    WEAKSELF
    _otherAppListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getotherAppList完成！");
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
//        strongSelf.collectionTableView.dataArray = service.dataList;
//        [strongSelf.collectionTableView reloadData];
        strongSelf.collectionView.dataArray = service.dataList;
        [strongSelf.collectionView reloadData];
        
    };
    _otherAppListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取失败"];
    };
    
    [_otherAppListService loadOtherAppListData];
    //    EHLogInfo(@"babyalarmlist.count = %lu",(unsigned long)self.babyAlarmList.count);
}

- (void)configGetOtherAppIntro
{
    _otherAppInfoService = [HSOtherAppInfoService new];
    
    WEAKSELF
    _otherAppInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getotherAppIntro完成！");
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
        strongSelf.appIntro = (HSApplicationIntroModel *)service.item;
        NSURL *appURLScheme = [NSURL URLWithString:strongSelf.appIntro.appDetailIos.appIOSURLScheme];
        BOOL isAppInstalled = [[UIApplication sharedApplication] canOpenURL:appURLScheme];
        if (isAppInstalled) {
            [[UIApplication sharedApplication] openURL:appURLScheme];
        }
        else{
            TBOpenURLFromSourceAndParams(internalURL(@"HSFamilyAppIntroViewController"), strongSelf,@{WEB_REQUEST_URL_ADDRESS_KEY:strongSelf.appIntro.appExtUrl,WEB_VIEW_TITLE_KEY:strongSelf.appIntro.appName});
        }

        
        
    };
    _otherAppInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"获取otherAppInfo失败"];
    };
    
}

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
            [strongSelf configGetOtherAppIntro];
            [strongSelf.otherAppInfoService loadOtherAppInfoWithAppId:appModel.appId];
        };
        return _collectionView;
    }
    return _collectionView;
}


//- (HSAppCollectionView *)collectionTableView{
//    if (!_collectionTableView) {
//        _collectionTableView = [[HSAppCollectionView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        WEAKSELF
//        _collectionTableView.appIdBlock = ^(NSString *appId){
//            STRONGSELF
//            [strongSelf configGetOtherAppIntro];
//            [strongSelf.otherAppInfoService loadOtherAppInfoWithAppId:appId];
//        };
//    }
//    return _collectionTableView;
//}








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
