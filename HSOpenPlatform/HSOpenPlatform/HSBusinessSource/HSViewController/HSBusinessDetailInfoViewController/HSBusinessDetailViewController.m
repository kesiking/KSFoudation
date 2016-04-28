//
//  HSBusinessDetailViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessDetailViewController.h"
#import "HSBussinessDetailVerticalContainer.h"
#import "HSDeviceInfoService.h"
#import "HSNavBarTitleCustomView.h"
#import "HSDeviceModel.h"
#import "HSDeviceInfoModel.h"

@interface HSBusinessDetailViewController()

@property (nonatomic,strong) HSBussinessDetailVerticalContainer  *bussinessDetailContainer;

@property (nonatomic,strong) HSNavBarTitleCustomView             *navBarTitleCustomView;

@property (nonatomic,strong) HSDeviceInfoService                 *businessDetailListService;

@property (nonatomic,strong) NSArray                             *businessDetailModelList;

@property (nonatomic,strong) HSPopMenuListView                   *popMenuListView;

@property (nonatomic,strong) HSDeviceModel                       *deviceModel;

@property (nonatomic,strong) NSNumber                            *productId;

@property (nonatomic,strong) NSNumber                            *deviceId;

@end

@implementation HSBusinessDetailViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.deviceModel = [nativeParams objectForKey:@"deviceModel"];
        self.productId = [nativeParams objectForKey:@"productId"]?:self.deviceModel.productId;
        self.deviceId = ((HSDeviceInfoModel*)[self.deviceModel.deviceData firstObject]).deviceId;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initBusinessDetail];
    [self refreshDataRequest];
}

-(void)initNavigationBar{
    self.navigationItem.titleView = self.navBarTitleCustomView;
}

-(void)initBusinessDetail{
    [self.bussinessDetailContainer setOpaque:YES];
}

-(void)refreshDataRequest{
    if (self.deviceModel == nil || ![self.deviceModel isKindOfClass:[HSDeviceModel class]]) {
        [self.businessDetailListService loadDeviceInfoWithUserPhone:[KSAuthenticationCenter userPhone] deviceId:self.deviceId];
    }else{
        [self refreshPopMenuListViewWithDatalist:self.deviceModel.deviceData];
        [self setBusinessDetailModelList:self.deviceModel.deviceData];
        [self refreshBusinessDetailContainerWithModel:[self.deviceModel.deviceData firstObject]];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitCustomView(navBarTitleCustomView, HSNavBarTitleCustomView,{
    [_navBarTitleCustomView setFrame:CGRectMake(0, 0, 200, 44)];
    [_navBarTitleCustomView setBtnTitle:self.deviceModel.productName];
    WEAKSELF
    _navBarTitleCustomView.buttonClicedBlock = ^(HSNavBarTitleCustomView* navBarTitleCustomView){
        STRONGSELF
        [strongSelf navBarTitleViewDidSelect:navBarTitleCustomView];
    };
})

KSPropertyInitCustomView(bussinessDetailContainer, HSBussinessDetailVerticalContainer,{
    [_bussinessDetailContainer setFrame:self.view.bounds];
    [_bussinessDetailContainer setProductId:self.productId];
    [_bussinessDetailContainer setDeviceModel:self.deviceModel];
})

KSPropertyInitCustomView(popMenuListView, HSPopMenuListView,{
    WEAKSELF
    [_popMenuListView setMenuListSelectedBlock:^(NSUInteger index, EHPopMenuModel* selectItem){
        STRONGSELF
        [strongSelf.navBarTitleCustomView setButtonSelected:YES];
        [strongSelf refreshBusinessDetailContainerWithModel:[selectItem menuExtModel]];
    }];
    [_popMenuListView setMenuDidCancelBlock:^{
        STRONGSELF
        [strongSelf.navBarTitleCustomView setButtonSelected:YES];
    }];
    _popMenuListView.alpha = 0;
    _popMenuListView.menuCellSize = CGSizeMake(185, 44);
    UIButton* bgCancelBtn = [_popMenuListView valueForKey:@"bgCancelBtn"];
    bgCancelBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
})

-(HSDeviceInfoService *)businessDetailListService{
    if (_businessDetailListService == nil) {
        _businessDetailListService = [HSDeviceInfoService new];
        
        WEAKSELF
        _businessDetailListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        
        _businessDetailListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            if (service.item && [service.item isKindOfClass:[HSDeviceInfoModel class]]) {
                HSDeviceInfoModel* deviceModel = (HSDeviceInfoModel*)service.item;
                strongSelf.navBarTitleCustomView.btn.enabled = YES;
                NSArray* deviceModels = @[deviceModel];
                [strongSelf refreshPopMenuListViewWithDatalist:deviceModels];
                [strongSelf setBusinessDetailModelList:deviceModels];
                [strongSelf refreshBusinessDetailContainerWithModel:deviceModel];
                [strongSelf hideEmptyView];
            }else{
                strongSelf.navBarTitleCustomView.btn.enabled = NO;
                [strongSelf showEmptyView];
            }
        };
        
        _businessDetailListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError *error){
            STRONGSELF
            strongSelf.navBarTitleCustomView.btn.enabled = NO;
            [strongSelf hideLoadingView];
            [strongSelf showErrorView:error];
        };
    }
    return _businessDetailListService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - popMenuListView action
-(void)navBarTitleViewDidSelect:(HSNavBarTitleCustomView*)navBarTitleCustomView{
    if (navBarTitleCustomView.btnIsSelected && self.businessDetailModelList && [self.businessDetailModelList count] > 0) {
        [self.popMenuListView showMenuOnView:self.view atPoint:CGPointMake((self.view.width - self.popMenuListView.menuCellSize.width)/2, 15)];
    }else{
        [self.popMenuListView dissMissPopMenuWithAnimated:YES];
    }
}

-(void)refreshPopMenuListViewWithDatalist:(NSArray*)dataList{
    NSMutableArray* menuArray = [NSMutableArray array];
    for (HSDeviceInfoModel* componentItem in dataList) {
        if (![componentItem isKindOfClass:[HSDeviceInfoModel class]]) {
            continue;
        }
        EHPopMenuModel* menu = [[EHPopMenuModel alloc] initWithTitleText:[componentItem valueForKey:@"deviceModel"]];
        menu.menuExtModel = componentItem;
        [menuArray addObject:menu];
    }
    [self.popMenuListView refreshMenuWithModelArray:menuArray];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - businessContaier refresh action
-(void)refreshBusinessDetailContainerWithModel:(HSDeviceInfoModel*)businessDetailModel{
    if (businessDetailModel == nil || ![businessDetailModel isKindOfClass:[HSDeviceInfoModel class]]) {
        return;
    }
    [_bussinessDetailContainer setBussinessDetailModel:businessDetailModel];
}

@end
