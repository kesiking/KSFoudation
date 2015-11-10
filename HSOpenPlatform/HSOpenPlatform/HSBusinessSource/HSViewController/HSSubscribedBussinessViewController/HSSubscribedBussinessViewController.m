//
//  HSSubscribedBussinessViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSSubscribedBussinessViewController.h"
#import "KSPageControllerContainer.h"
#import "HSSubscribedBussinessView.h"
#import "WeAppSelectorItem.h"

#define selectorButtonRectHeight (44.0)

@interface HSSubscribedBussinessViewController ()<KSPageControllerViewDelegate, KSPageControllerSelectorDelegate>

@property (nonatomic, strong) KSPageControllerContainer      *pageControllerContainer;

@property (nonatomic, strong) HSSubscribedBussinessView      *comboViewContainer;

@property (nonatomic, strong) HSSubscribedBussinessView      *familyViewContainer;

@property (nonatomic, strong) HSSubscribedBussinessView      *incrementViewContainer;

@property (nonatomic, strong) HSSubscribedBussinessView      *preferentialViewContainer;

@end

@implementation HSSubscribedBussinessViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已订业务";
    [self.view addSubview:self.pageControllerContainer];
    NSArray* array = @[@{@"title":@"套餐"},
                       @{@"title":@"家庭业务"},
                       @{@"title":@"增值业务"},
                       @{@"title":@"优惠"}];
    NSArray* selectorItemArray = [WeAppSelectorItem modelArrayWithJSON:array];
    [self.pageControllerContainer.selectorDataSource removeAllObjects];
    [self.pageControllerContainer.selectorDataSource addObjectsFromArray:selectorItemArray];
    
    [self.pageControllerContainer reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - pageControllerContainer method
-(KSPageControllerContainer *)pageControllerContainer{
    if (_pageControllerContainer == nil) {
        _pageControllerContainer = [[KSPageControllerContainer alloc] initWithFrame:self.view.bounds selectorButtonRect:CGRectMake(0, 0, self.view.width / 4, selectorButtonRectHeight)];
        [[_pageControllerContainer.selectorView getIndicatorView] setBackgroundColor:EH_cor9];
        _pageControllerContainer.pageControllerViewDelegate = self;
        _pageControllerContainer.selectorViewDelegate = self;
    }
    
    return _pageControllerContainer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subscribedBussinessView method

-(HSSubscribedBussinessView *)comboViewContainer{
    if (_comboViewContainer == nil) {
        _comboViewContainer = [[HSSubscribedBussinessView alloc] initWithFrame:self.pageControllerContainer.bounds];;
        HSSubscribedBussinessBasicService* service = [HSSubscribedBussinessBasicService new];
        [_comboViewContainer setSubscribedBussinessListService:service];
        [service loadSubscribedBussinessDataListWithUserPhone:[KSAuthenticationCenter userPhone] bussinessId:comboSubscribedBussinessKey];
    }
    return _comboViewContainer;
}

-(HSSubscribedBussinessView *)familyViewContainer{
    if (_familyViewContainer == nil) {
        _familyViewContainer = [[HSSubscribedBussinessView alloc] initWithFrame:self.pageControllerContainer.bounds];
        HSSubscribedBussinessBasicService* service = [HSSubscribedBussinessBasicService new];
        [_familyViewContainer setSubscribedBussinessListService:service];
        [service loadSubscribedBussinessDataListWithUserPhone:[KSAuthenticationCenter userPhone] bussinessId:familySubscribedBussinessKey];

    }
    return _familyViewContainer;
}

-(HSSubscribedBussinessView *)incrementViewContainer{
    if (_incrementViewContainer == nil) {
        _incrementViewContainer = [[HSSubscribedBussinessView alloc] initWithFrame:self.pageControllerContainer.bounds];
        HSSubscribedBussinessBasicService* service = [HSSubscribedBussinessBasicService new];
        [_incrementViewContainer setSubscribedBussinessListService:service];
        [service loadSubscribedBussinessDataListWithUserPhone:[KSAuthenticationCenter userPhone] bussinessId:incrementSubscribedBussinessKey];
    }
    return _incrementViewContainer;
}

-(HSSubscribedBussinessView *)preferentialViewContainer{
    if (_preferentialViewContainer == nil) {
        _preferentialViewContainer = [[HSSubscribedBussinessView alloc] initWithFrame:self.pageControllerContainer.bounds];
        HSSubscribedBussinessBasicService* service = [HSSubscribedBussinessBasicService new];
        [_preferentialViewContainer setSubscribedBussinessListService:service];
        [service loadSubscribedBussinessDataListWithUserPhone:[KSAuthenticationCenter userPhone] bussinessId:preferentialSubscribedBussinessKey];
    }
    return _preferentialViewContainer;
}

-(HSSubscribedBussinessView*)getSubscribedBussinessViewWithIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            return self.comboViewContainer;
        }
            break;
        case 1:{
            return self.familyViewContainer;
        }
            break;
        case 2:{
            return self.incrementViewContainer;
        }
            break;
        case 3:{
            return self.preferentialViewContainer;
        }
            break;
        default:
            break;
    }
    return self.comboViewContainer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSPageControllerViewDelegate method 配置翻页属性
- (NSUInteger)numberOfSectionsInPageControllerView:(TBPageControllerView*)pageControllerView{
    return [self.pageControllerContainer.selectorDataSource count];// 共四页
}

// 返回每一页的实例
- (UIControl*)pageControllerView:(TBPageControllerView*)pageControllerView atIndex:(NSUInteger)itemIndex{
    NSString* subscribedBussinessReusableControlIdetifier = @"subscribedBussinessReusableControl";
    UIControl *control = (UIControl *)[self.pageControllerContainer dequeueReusableControlWithIdentifier:subscribedBussinessReusableControlIdetifier withItemIndex:itemIndex];
    if (control == nil) {
        control = [self getSubscribedBussinessViewWithIndex:itemIndex];
        [self.pageControllerContainer setControlWithControl:control reuseIdentifier:subscribedBussinessReusableControlIdetifier withItemIndex:itemIndex];
    }
    return control;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSPageControllerSelectorDelegate method 配置顶部选择栏按钮的样式
-(void)pageControllerSelectorProperty:(WeAppSelectorButton*)itemView selectorItem:(id)selectorItem withIndex:(NSUInteger)index isSelect:(BOOL)isSelect isFirstConfig:(BOOL)firstConfig{
    if(![selectorItem isKindOfClass:[WeAppSelectorItem class]]){
        return;
    }
    WeAppSelectorItem *weappSelectorItem = (WeAppSelectorItem*)selectorItem;
    if (firstConfig) {
        //文案填充
        if (weappSelectorItem.title && weappSelectorItem.title.length > 0) {
            [itemView setTitle:weappSelectorItem.title forState:UIControlStateNormal];
        }
    }
    [self setSelectorView:itemView selectorItem:weappSelectorItem isSelect:isSelect];
}

//改变
-(void)setSelectorView:(WeAppSelectorButton*)selectorView selectorItem:(WeAppSelectorItem*)selectorItem isSelect:(BOOL)isSelect{
    //选中样式
    if (isSelect) {
        [selectorView.imageButton setTitleColor:EH_cor9 forState:UIControlStateNormal];
        [selectorView.imageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:EH_siz4]];
    }else{
        //不选中的样式
        [selectorView.imageButton setTitleColor:EH_cor3 forState:UIControlStateNormal];
        [selectorView.imageButton.titleLabel setFont:[UIFont systemFontOfSize:EH_siz5]];
    }
}

@end
