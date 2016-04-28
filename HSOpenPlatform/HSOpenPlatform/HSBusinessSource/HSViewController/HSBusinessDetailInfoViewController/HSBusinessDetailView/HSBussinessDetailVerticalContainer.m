//
//  HSBussinessDetailVerticalContainer.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBussinessDetailVerticalContainer.h"
#import "HSBusinessInfoHeaderView.h"
#import "HSBusinessUserListView.h"
#import "HSBussinessComboInfoView.h"
#import "HSBussinessAfterSaleLInkView.h"

#define BussinessDetailBorderPaddingLeft   (0.0)
#define BussinessDetailBorderPaddingRight  (BussinessDetailBorderLeft)

#define BussinessDetailBorderPaddingTop    (0.0)
#define BussinessDetailBorderPaddingBottom (15.0)

@interface HSBussinessDetailVerticalContainer()

@property (nonatomic, strong) CSLinearLayoutView                    *container;

@property (nonatomic, strong) HSBusinessInfoHeaderView              *businessInfoHeaderView;
@property (nonatomic, strong) HSBusinessUserListView                *businessUserListView;
@property (nonatomic, strong) HSBussinessComboInfoView              *businessComboInfoView;
@property (nonatomic, strong) HSBussinessAfterSaleLInkView          *businessAfterSaleLinkView;

@end

@implementation HSBussinessDetailVerticalContainer

-(void)setupView{
    [super setupView];
    [self addSubview:self.container];
}

-(void)setBussinessDetailModel:(HSDeviceInfoModel *)bussinessDetailModel{
    _bussinessDetailModel = bussinessDetailModel;
    if (bussinessDetailModel != nil) {
        [self setDeviceId:bussinessDetailModel.deviceId];
        [self reloadDataAndContaier];
    }
}

-(void)setDeviceModel:(HSDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    [self.businessInfoHeaderView setDeviceModel:deviceModel];
    [self.businessUserListView setDeviceModel:deviceModel];
    [self.businessComboInfoView setDeviceModel:deviceModel];
    [self.businessAfterSaleLinkView setDeviceModel:deviceModel];
}

-(void)setProductId:(NSNumber *)productId{
    _productId = productId;
    [self.businessInfoHeaderView setProductId:productId];
    [self.businessUserListView setProductId:productId];
    [self.businessComboInfoView setProductId:productId];
    [self.businessAfterSaleLinkView setProductId:productId];
}

-(void)setDeviceId:(NSNumber *)deviceId{
    _deviceId = deviceId;
    [self.businessInfoHeaderView setDeviceId:deviceId];
    [self.businessUserListView setDeviceId:deviceId];
    [self.businessComboInfoView setDeviceId:deviceId];
    [self.businessAfterSaleLinkView setDeviceId:deviceId];
}

-(void)dealloc{
    [self.container removeAllItems];
    [self.container removeAllSubviews];
    self.container = nil;
    self.businessInfoHeaderView = nil;
    self.businessUserListView = nil;
    self.businessComboInfoView = nil;
    self.businessAfterSaleLinkView = nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_businessInfoHeaderView.width != self.width) {
        [_businessInfoHeaderView setWidth:self.width];
    }
    if (_businessUserListView.width != self.width) {
        [_businessUserListView setWidth:self.width];
    }
    if (_businessComboInfoView.width != self.width) {
        [_businessComboInfoView setWidth:self.width];
    }
    if (_businessAfterSaleLinkView.width != self.width) {
        [_businessAfterSaleLinkView setWidth:self.width];
    }
    if (!CGRectEqualToRect(self.container.frame, self.bounds)) {
        [self.container setFrame:self.bounds];
        [self reloadContainer];
    }
}

-(void)reloadDataAndContaier{
    [self reloadData];
    [self reloadContainer];
}

-(void)reloadData{
    [self.businessInfoHeaderView setBussinessDetailModel:self.bussinessDetailModel];
    [self.businessUserListView setBussinessDetailModel:self.bussinessDetailModel];
    [self.businessComboInfoView setBussinessDetailModel:self.bussinessDetailModel];
    [self.businessAfterSaleLinkView setBussinessDetailModel:self.bussinessDetailModel];
}

-(void)reloadContainer{
    [self.container removeAllItems];
    
    CGPoint containerOffset           = self.container.contentOffset;
    CSLinearLayoutItemPadding padding = CSLinearLayoutMakePadding(BussinessDetailBorderPaddingTop, BussinessDetailBorderPaddingLeft, BussinessDetailBorderPaddingBottom, BussinessDetailBorderPaddingRight);
    
    CSLinearLayoutItem *businessInfoHeaderViewItem = [[CSLinearLayoutItem alloc] initWithView:self.businessInfoHeaderView];
    businessInfoHeaderViewItem.padding = padding;
    [self.businessInfoHeaderView sizeToFit];
    [self.container addItem:businessInfoHeaderViewItem];
    
    CSLinearLayoutItem *businessUserListViewItem = [[CSLinearLayoutItem alloc] initWithView:self.businessUserListView];
    businessUserListViewItem.padding = padding;
    [self.businessUserListView sizeToFit];
    [self.container addItem:businessUserListViewItem];
    
    CSLinearLayoutItem *businessComboInfoViewItem = [[CSLinearLayoutItem alloc] initWithView:self.businessComboInfoView];
    businessComboInfoViewItem.padding = padding;
    [self.businessComboInfoView sizeToFit];
    [self.container addItem:businessComboInfoViewItem];
    
    CSLinearLayoutItem *businessAfterSaleLinkViewItem = [[CSLinearLayoutItem alloc] initWithView:self.businessAfterSaleLinkView];
    businessAfterSaleLinkViewItem.padding = padding;
    [self.businessAfterSaleLinkView sizeToFit];
    [self.container addItem:businessAfterSaleLinkViewItem];
    
    /*调整布局*/
    if (self.container.contentSize.height > self.container.height) {
        [self.container setContentOffset:containerOffset];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - business related view
KSPropertyInitCustomView(businessInfoHeaderView, HSBusinessInfoHeaderView,{
    [_businessInfoHeaderView setFrame:CGRectMake(0, 0, self.width, 90)];
    [_businessInfoHeaderView setBackgroundColor:[UIColor whiteColor]];
})

KSPropertyInitCustomView(businessUserListView, HSBusinessUserListView,{
    [_businessUserListView setFrame:CGRectMake(0, 0, self.width, 60)];
    [_businessUserListView setBackgroundColor:[UIColor whiteColor]];
})

KSPropertyInitCustomView(businessComboInfoView, HSBussinessComboInfoView,{
    [_businessComboInfoView setFrame:CGRectMake(0, 0, self.width, 0)];
    [_businessComboInfoView setBackgroundColor:[UIColor whiteColor]];
    WEAKSELF
    [_businessComboInfoView setBusinessViewDidSelectBlock:^ (HSBusinessInfoBasicView* view){
        STRONGSELF
        if(strongSelf.businessComboInfoView.linearLayoutItem){
            strongSelf.businessComboInfoView.linearLayoutItem.animationChangeFrame = YES;
        }
        if(strongSelf.businessAfterSaleLinkView.linearLayoutItem){
            strongSelf.businessAfterSaleLinkView.linearLayoutItem.animationChangeFrame = YES;
        }
    }];
})

KSPropertyInitCustomView(businessAfterSaleLinkView, HSBussinessAfterSaleLInkView,{
    [_businessAfterSaleLinkView setFrame:CGRectMake(0, 0, self.width,44)];
    [_businessAfterSaleLinkView setBackgroundColor:[UIColor whiteColor]];
})

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - container
KSPropertyInitCustomView(container,CSLinearLayoutView,{
    float containerHeight = self.height;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, containerHeight);
    _container = [[CSLinearLayoutView alloc] initWithFrame:frame];
    _container.alwaysBounceVertical = YES;
    _container.backgroundColor = EH_cor1;
})

@end
