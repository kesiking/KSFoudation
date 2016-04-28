//
//  HSActivityInfoDetailViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/14.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoDetailViewController.h"
#import "HSActivityInfoDetailView.h"
#import "HSActivityInfoDetailService.h"

void HSActivityInfoDetailOpenURLFromTargetWithNativeParams (id source, NSDictionary* params, NSDictionary *nativeParams, HSActivityInfoModel* activityInfoModel) {
    __weak __typeof(source) weakSource = source;
    dispatch_block_t openURLBlock = ^(){
        if (activityInfoModel.activityUrl) {
            TBOpenURLFromTargetWithNativeParams(activityInfoModel.activityUrl, weakSource, params, nativeParams);
        }else{
            TBOpenURLFromTargetWithNativeParams((kHSOPActivityInfoDetail), weakSource, params, nativeParams);
        }
    };
    if ([activityInfoModel.needLogin boolValue]) {
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:^(BOOL loginSuccess) {
            if (openURLBlock) {
                openURLBlock();
            }
        } cancelActionBlock:nil];
    }else{
        if (openURLBlock) {
            openURLBlock();
        }
    }
}

@interface HSActivityInfoDetailViewController ()

@property (nonatomic, strong) HSActivityInfoDetailView       *activityInfoDetailView;

@property (nonatomic, strong) HSActivityInfoModel            *activityInfoModel;

@property (nonatomic, strong) NSString                       *activityId;

@property (nonatomic, strong) HSActivityInfoDetailService    *activityInfoDetailService;

@end

@implementation HSActivityInfoDetailViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.activityInfoModel = [nativeParams objectForKey:@"activityInfoModel"];
        self.activityId = [nativeParams objectForKey:@"activityId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initActivityNavBarViews];
    [self initActivityDetailView];
    [self initActivityInfoDetailService];
}

-(void)initActivityNavBarViews{
    self.title = @"活动详情";
}

-(void)initActivityDetailView{
    [self.view addSubview:self.activityInfoDetailView];
}

-(void)initActivityInfoDetailService{
    if (self.activityInfoModel == nil && self.activityId != nil) {
        [self.activityInfoDetailService loadActivityInfoDetailWithActivityId:self.activityId userPhone:[KSAuthenticationCenter userPhone]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载    activityInfoListView

-(HSActivityInfoDetailView *)activityInfoDetailView{
    if (_activityInfoDetailView == nil) {
        _activityInfoDetailView = [[HSActivityInfoDetailView alloc] initWithFrame:self.view.bounds];
        [_activityInfoDetailView setActivityViewController:self];
        [_activityInfoDetailView setActivityInfoModel:self.activityInfoModel];
    }
    return _activityInfoDetailView;
}

-(HSActivityInfoDetailService *)activityInfoDetailService{
    if (_activityInfoDetailService == nil) {
        _activityInfoDetailService = [HSActivityInfoDetailService new];
        WEAKSELF
        _activityInfoDetailService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            if (service.item && [service.item isKindOfClass:[HSActivityInfoModel class]]) {
                [strongSelf.activityInfoDetailView setActivityInfoModel:(HSActivityInfoModel*)service.item];
            }
        };
        
        KSServiceDidFailLoadBlock(_activityInfoDetailService,{
            STRONGSELF
            [strongSelf hideLoadingView];
        })
    }
    return _activityInfoDetailService;
}

@end
