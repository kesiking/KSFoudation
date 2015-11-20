//
//  HSBusinessDetailViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessDetailViewController.h"
#import "HSBussinessDetailVerticalContainer.h"
#import "HSBusinessDetailListService.h"
#import "HSNavBarTitleCustomView.h"
#import "HSApplicationModel.h"

@interface HSBusinessDetailViewController()

@property (nonatomic,strong) HSBussinessDetailVerticalContainer  *bussinessDetailContainer;

@property (nonatomic,strong) HSNavBarTitleCustomView             *navBarTitleCustomView;

@property (nonatomic,strong) HSBusinessDetailListService         *businessDetailListService;

@property (nonatomic,strong) NSArray                             *businessDetailModelList;

@property (nonatomic,strong) HSPopMenuListView                   *popMenuListView;

@property (nonatomic,strong) HSApplicationModel                  *appModel;

@property (nonatomic,strong) NSString                            *appId;

@end

@implementation HSBusinessDetailViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.appModel = [nativeParams objectForKey:@"appModel"];
        self.appId = [nativeParams objectForKey:@"appId"];
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
//    [self.businessDetailListService loadBusinessDetailListWithUserPhone:[KSAuthenticationCenter userPhone] appId:self.appId];
    NSArray* businessDetailModelArray = @[
                                  @{
                                      @"appId":@"1",
                                      @"businessId":@"1",
                                      @"businessNickName":@"我的魔百盒"
                                      },
                                  @{
                                      @"appId":@"1",
                                      @"businessId":@"2",
                                      @"businessNickName":@"我的魔百盒1"
                                      },
                                  @{
                                      @"appId":@"1",
                                      @"businessId":@"3",
                                      @"businessNickName":@"我的魔百盒2"
                                      }
                                  ];
    NSArray* businessDetailModels = [HSBusinessDetailModel modelArrayWithJSON:businessDetailModelArray];
    [self refreshPopMenuListViewWithDatalist:businessDetailModels];
    [self setBusinessDetailModelList:businessDetailModels];
    [self refreshBusinessDetailContainerWithModel:[businessDetailModels firstObject]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitCustomView(navBarTitleCustomView, HSNavBarTitleCustomView,{
    [_navBarTitleCustomView setFrame:CGRectMake(0, 0, 200, 44)];
    [_navBarTitleCustomView setBtnTitle:self.appModel.appName];
    WEAKSELF
    _navBarTitleCustomView.buttonClicedBlock = ^(HSNavBarTitleCustomView* navBarTitleCustomView){
        STRONGSELF
        [strongSelf navBarTitleViewDidSelect:navBarTitleCustomView];
    };
})

KSPropertyInitCustomView(bussinessDetailContainer, HSBussinessDetailVerticalContainer,{
    [_bussinessDetailContainer setFrame:self.view.bounds];
    [_bussinessDetailContainer setAppModel:self.appModel];
    [_bussinessDetailContainer setAppId:self.appId];
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

-(HSBusinessDetailListService *)businessDetailListService{
    if (_businessDetailListService == nil) {
        _businessDetailListService = [HSBusinessDetailListService new];
        
        WEAKSELF
        _businessDetailListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        
        _businessDetailListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            if (service.dataList && [service.dataList count] > 0) {
                strongSelf.navBarTitleCustomView.btn.enabled = YES;
                [strongSelf refreshPopMenuListViewWithDatalist:service.dataList];
                [strongSelf setBusinessDetailModelList:service.dataList];
                [strongSelf refreshBusinessDetailContainerWithModel:[service.dataList firstObject]];
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
    for (HSBusinessDetailModel* componentItem in dataList) {
        if (![componentItem isKindOfClass:[HSBusinessDetailModel class]]) {
            continue;
        }
        EHPopMenuModel* menu = [[EHPopMenuModel alloc] initWithTitleText:[componentItem valueForKey:@"businessNickName"]];
        menu.menuExtModel = componentItem;
        [menuArray addObject:menu];
    }
    [self.popMenuListView refreshMenuWithModelArray:menuArray];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - businessContaier refresh action
-(void)refreshBusinessDetailContainerWithModel:(HSBusinessDetailModel*)businessDetailModel{
    if (businessDetailModel == nil || ![businessDetailModel isKindOfClass:[HSBusinessDetailModel class]]) {
        return;
    }
    [_bussinessDetailContainer setBussinessDetailModel:businessDetailModel];
}

@end
