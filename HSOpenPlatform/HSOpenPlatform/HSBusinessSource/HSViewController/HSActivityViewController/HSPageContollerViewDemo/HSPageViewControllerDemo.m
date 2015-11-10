//
//  HSPageViewControllerDemo.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/15.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSPageViewControllerDemo.h"
#import "KSPageControllerContainer.h"
#import "WeAppSelectorItem.h"

@interface HSPageViewControllerDemo ()<KSPageControllerViewDelegate, KSPageControllerSelectorDelegate>

@property (nonatomic, strong) KSPageControllerContainer      *pageControllerContainer;

@end

@implementation HSPageViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.pageControllerContainer];
    
    NSArray* array = @[@{@"title":@"title1"},@{@"title":@"title2"},@{@"title":@"title3"},@{@"title":@"title4"},@{@"title":@"title5"},@{@"title":@"title6"},@{@"title":@"title7"},@{@"title":@"title8"},@{@"title":@"title9"}];
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
        _pageControllerContainer = [[KSPageControllerContainer alloc] initWithFrame:self.view.bounds selectorButtonRect:CGRectMake(0, 0, 0, 44)];
        _pageControllerContainer.pageControllerViewDelegate = self;
        _pageControllerContainer.selectorViewDelegate = self;
    }
    return _pageControllerContainer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSPageControllerViewDelegate method 配置翻页属性
- (NSUInteger)numberOfSectionsInPageControllerView:(TBPageControllerView*)pageControllerView{
    return [self.pageControllerContainer.selectorDataSource count];// 共三页
}

// 返回每一页的实例
- (UIControl*)pageControllerView:(TBPageControllerView*)pageControllerView atIndex:(NSUInteger)itemIndex{
    UIControl *control = (UIControl *)[self.pageControllerContainer dequeueReusableControlWithIdentifier:@"reusableControl" withItemIndex:itemIndex];
    if (control == nil) {
        control = [[UIControl alloc] initWithFrame:pageControllerView.bounds];
        control.backgroundColor = [UIColor colorWithWhite:itemIndex/((float)(self.pageControllerContainer.selectorDataSource.count - 1)) alpha:1.0];
        [self.pageControllerContainer setControlWithControl:control reuseIdentifier:@"reusableControl" withItemIndex:itemIndex];
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
        [selectorView.imageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [selectorView.imageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }else{
        //不选中的样式
        [selectorView.imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectorView.imageButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
}

@end
