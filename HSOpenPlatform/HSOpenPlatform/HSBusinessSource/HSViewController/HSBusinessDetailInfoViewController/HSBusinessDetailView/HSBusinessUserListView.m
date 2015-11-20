//
//  HSBusinessUserListView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserListView.h"
#import "HSBasicListView.h"
#import "HSBusinessUserAccountInfoModel.h"
#import "HSBusinessUserListInfoViewCell.h"
#import "HSBusinessUserInfoListService.h"
#import "HSBusinessUserInfoEditAlertView.h"

@interface HSBusinessUserListView()<UIAlertViewDelegate>

@property (nonatomic, strong) UILabel               *businessUserListTitleLabel;

@property (nonatomic, strong) UIView                *businessUserListTitleLabelLine;

@property (nonatomic, strong) KSTableViewController *businessUserListView;

@property (nonatomic, strong) HSBusinessUserInfoListService* userInfoListService;

@property (nonatomic, strong) HSBusinessUserInfoEditAlertView* userInfoEditAlertView;

@end

@implementation HSBusinessUserListView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public override method
-(void)setupView{
    [super setupView];
    [self.businessUserListTitleLabel setOpaque:YES];
    [self.businessUserListTitleLabelLine setOpaque:YES];
    [self.businessUserListView.scrollView setOpaque:YES];
    [self.endline setOpaque:YES];
    [self.topline setOpaque:YES];
}

-(void)reloadData{
    /*
     * mock data
    NSArray* sortAndFiltArray = @[
                                  @{
                                      @"userAccountPhone":@"15088604829",
                                      @"userAccountName":@"test0",
                                      @"isUserAccountHousehold":@YES
                                      },
                                  @{
                                      @"userAccountPhone":@"15088604821",
                                      @"userAccountName":@"张三"
                                      },
                                  @{
                                      @"userAccountPhone":@"15088604822",
                                      @"userAccountName":@"李四"
                                      }
                                  ];
    NSArray* commoditySortAndFiltModels = [HSBusinessUserAccountInfoModel modelArrayWithJSON:sortAndFiltArray];
    [self.businessUserListView.dataSourceRead setDataWithPageList:commoditySortAndFiltModels extraDataSource:nil];
    [self.businessUserListView reloadData];
    [self.businessUserListView sizeToFit];
    */
    [self.userInfoListService loadBusinessUserInfoListWithUserPhone:[KSAuthenticationCenter userPhone] appId:self.appId?:[self.bussinessDetailModel valueForKey:@"appId"]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitLabelView(businessUserListTitleLabel,{
    [_businessUserListTitleLabel setFrame:CGRectMake(BussinessDetailBorderLeft, 0, BussinessDetailWidth, 44)];
    [_businessUserListTitleLabel setText:@"设备共享成员"];
    [_businessUserListTitleLabel setNumberOfLines:1];
    [_businessUserListTitleLabel setFont:[UIFont boldSystemFontOfSize:EHSiz2]];
    [_businessUserListTitleLabel setTextColor:EHCor5];
    [_businessUserListTitleLabel setTextAlignment:NSTextAlignmentLeft];
})

-(UIView *)businessUserListTitleLabelLine{
    if (_businessUserListTitleLabelLine == nil) {
        _businessUserListTitleLabelLine = [TBDetailUITools drawDivisionLine:0
                                                                          yPos:self.businessUserListTitleLabel.bottom - 0.5
                                                                     lineWidth:self.width];
        [_businessUserListTitleLabelLine setBackgroundColor:EH_cor13];
        [self addSubview:_businessUserListTitleLabelLine];
    }
    return _businessUserListTitleLabelLine;
}

-(KSTableViewController *)businessUserListView{
    if (_businessUserListView == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        configObject.needRefreshView = NO;
        configObject.needNextPage = NO;
        configObject.needQueueLoadData = NO;
        configObject.needErrorView = NO;
        [configObject setAutoAdjustFrameSize:YES];
        [configObject setCollectionCellSize:CGSizeMake(self.width, 44)];
        CGRect frame = CGRectMake(0, self.businessUserListTitleLabel.bottom, self.width, 0);
        _businessUserListView = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_businessUserListView registerClass:NSClassFromString(@"HSBusinessUserListInfoViewCell")];
        [_businessUserListView setErrorViewTitle:@"暂无信息"];
        [_businessUserListView setHasNoDataFootViewTitle:@"已无信息可同步"];
        [_businessUserListView setNextFootViewTitle:@""];
        
        [_businessUserListView getTableView].separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_businessUserListView getTableView].separatorColor = EH_cor13;

        WEAKSELF
        [_businessUserListView setTableViewDidSelectedBlock:^(UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject){
            STRONGSELF
             HSBusinessUserAccountInfoModel* accountInfoModel = (HSBusinessUserAccountInfoModel*)[dataSource getComponentItemWithIndex:[indexPath row]];
            if (![accountInfoModel isKindOfClass:[HSBusinessUserAccountInfoModel class]]) {
                return ;
            }
            /*
             * 跳转新的页面编辑name
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            if (strongSelf.appId){
                [params setObject:strongSelf.appId forKey:@"appId"];
            }else if ([strongSelf.bussinessDetailModel valueForKey:@"appId"]) {
                [params setObject:[strongSelf.bussinessDetailModel valueForKey:@"appId"] forKey:@"appId"];
            }
            if (accountInfoModel.userAccountPhone) {
                [params setObject:accountInfoModel.userAccountPhone forKey:@"userPhone"];
            }
            if (accountInfoModel.userAccountName) {
                [params setObject:accountInfoModel.userAccountName forKey:@"userTrueName"];
            }
            if (accountInfoModel.userAccountNickName) {
                [params setObject:accountInfoModel.userAccountNickName forKey:@"userNickName"];
            }
            TBOpenURLFromSourceAndParams(@"HSBusinessUserInfoEditViewController", strongSelf, params);
             */
            
            [strongSelf.userInfoEditAlertView setUserPhone:accountInfoModel.userAccountPhone];
            [strongSelf.userInfoEditAlertView setAppId:strongSelf.appId?:[strongSelf.bussinessDetailModel valueForKey:@"appId"]];
            [strongSelf.userInfoEditAlertView setUserTrueName:accountInfoModel.userAccountName];
            [strongSelf.userInfoEditAlertView setUserNickName:accountInfoModel.userAccountNickName];
            [strongSelf.userInfoEditAlertView setAlertContext:accountInfoModel];
            [strongSelf.userInfoEditAlertView show];

        }];
        
        [_businessUserListView setScrollViewFrameSizeToFitDidFinished:^(KSScrollViewServiceController* scrollViewController, CGRect newFrame, CGRect oldFrame){
            STRONGSELF
            [strongSelf sizeToFit];
        }];
        
        [_businessUserListView setService:self.userInfoListService];
        [self addSubview:_businessUserListView.scrollView];
    }
    return _businessUserListView;
}

-(HSBusinessUserInfoEditAlertView *)userInfoEditAlertView{
    if (_userInfoEditAlertView == nil) {
        _userInfoEditAlertView = [[HSBusinessUserInfoEditAlertView alloc] initWithTitle:@"编辑名称" message:nil
                                                              clickedButtonAtIndexBlock:nil cancelButtonTitle:@"取消" otherButtonTitles:@"保存"];
        WEAKSELF
        _userInfoEditAlertView.serviceDidStartedBlock = ^(EHAleatView * alertView, WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _userInfoEditAlertView.serviceDidFinishedBlock = ^(EHAleatView * alertView, WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
            HSBusinessUserAccountInfoModel *accountInfoModel = ((HSBusinessUserInfoEditAlertView*)alertView).alertContext;
            if (accountInfoModel == nil
                || ![accountInfoModel isKindOfClass:[HSBusinessUserAccountInfoModel class]]) {
                return;
            }
            accountInfoModel.userAccountNickName = ((HSBusinessUserInfoEditAlertView*)alertView).userNickName;
            [strongSelf.businessUserListView reloadData];
        };
        _userInfoEditAlertView.serviceDidFailedBlock = ^(EHAleatView * alertView, WeAppBasicService* service, NSError* error){
            STRONGSELF
            [WeAppToast toast:[error.userInfo objectForKey:@"NSLocalizedDescription"]?:UISYSTEM_FAILED_ERROR_TITLE toView:strongSelf.viewController.view];
            [strongSelf hideLoadingView];
        };
        _userInfoEditAlertView.alertToastContentBlock = ^(EHAleatView * alertView, NSString* toastMessage){
            STRONGSELF
            [WeAppToast toast:toastMessage toView:strongSelf.viewController.view];
        };
    }
    return _userInfoEditAlertView;
}

-(HSBusinessUserInfoListService *)userInfoListService{
    if (_userInfoListService == nil) {
        _userInfoListService = [HSBusinessUserInfoListService new];
    }
    return _userInfoListService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system override method
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_businessUserListTitleLabel.width != BussinessDetailWidth) {
        [_businessUserListTitleLabel setFrame:CGRectMake(BussinessDetailBorderLeft, 0, BussinessDetailWidth, _businessUserListTitleLabel.height)];
    }
    if (_businessUserListView.scrollView.width != self.width) {
         [_businessUserListView setFrame:CGRectMake(0, _businessUserListTitleLabel.bottom, self.width, _businessUserListView.scrollView.height)];
    }
    [_businessUserListTitleLabelLine setFrame:CGRectMake(_businessUserListTitleLabelLine.origin.x, _businessUserListTitleLabel.bottom - 0.5, self.width, _businessUserListTitleLabelLine.height)];
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, _businessUserListTitleLabel.height + _businessUserListView.scrollView.height);
}

@end
