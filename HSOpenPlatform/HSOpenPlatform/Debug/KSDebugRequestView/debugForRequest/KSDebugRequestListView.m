//
//  KSDebugRequestListView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestListView.h"
#import "KSDebugRequestVCModel.h"
#import "KSDebugRequestListCell.h"
#import "KSDebugRequestListHeaderView.h"

@interface KSDebugRequestListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sortedRequestArray;   //!< 按页面分类

@property (nonatomic, assign) KSDebugRequestListShowType showType;

@end

@implementation KSDebugRequestListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.requestArray = [[NSMutableArray alloc]init];
        self.sortedRequestArray = [[NSMutableArray alloc]init];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.tableHeaderView = nil;
        self.tableFooterView = [[UIView alloc]init];
        self.delegate = self;
        self.dataSource = self;
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSNumber *showType = [defaults objectForKey:KSDebugRequestShowTypeKey];
        if (!showType) {
            showType = @(KSDebugRequestListShowTypeDefault);
        }
        self.showType = [showType integerValue];

    }
    return self;
}

- (void)reloadData {
    [self reloadDataWithType:self.showType];
}

- (void)reloadDataWithType:(KSDebugRequestListShowType)showType {
    self.showType = showType;
    if (showType == KSDebugRequestListShowTypeSortByVC) {
        self.sortedRequestArray = [self requestArraySortedByVCName:self.requestArray];
    }
    [super reloadData];
}

- (NSMutableArray *)requestArraySortedByVCName:(NSMutableArray *)requestArray {
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    if (requestArray.count == 0) {
        return sortedArray;
    }
    
    BOOL isContained;
    for (KSDebugRequestModel *requestModel in requestArray) {
        isContained = NO;
        for (KSDebugRequestVCModel *VCModel in sortedArray) {
            if ([VCModel.requestedVC isEqualToString:requestModel.requestedVC]) {
                VCModel.requestCount++;
                VCModel.totalTime += requestModel.spendedTime;
                VCModel.flowCount += requestModel.response.expectedContentLength;
                [VCModel.requestArray addObject:requestModel];
                isContained = YES;
                break;
            }
        }
        if (!isContained) {
            KSDebugRequestVCModel *VCModel = [[KSDebugRequestVCModel alloc]init];
            VCModel.requestedVC = requestModel.requestedVC;
            VCModel.requestCount = 1;
            VCModel.latestTime = requestModel.startTime;
            VCModel.totalTime = requestModel.spendedTime;
            VCModel.flowCount = requestModel.response.expectedContentLength;
            [VCModel.requestArray addObject:requestModel];
            [sortedArray addObject:VCModel];
        }
    }
    return sortedArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:
            return 1;
        case KSDebugRequestListShowTypeSortByVC:
            return self.sortedRequestArray.count;
        default:
            return 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:
            return self.requestArray.count;
        case KSDebugRequestListShowTypeSortByVC: {
            KSDebugRequestVCModel *VCModel = self.sortedRequestArray[section];
            return VCModel.requestArray.count;
        }
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:
            return 0.1;
        case KSDebugRequestListShowTypeSortByVC:
            return ks_debug_requestListHeaderView_height;
        default:
            return 0.1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:
            return nil;
        case KSDebugRequestListShowTypeSortByVC: {
            KSDebugRequestListHeaderView *headerView = [[KSDebugRequestListHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, ks_debug_requestListHeaderView_height)];
            KSDebugRequestVCModel *VCModel = self.sortedRequestArray[section];
            [headerView configWithVCModel:VCModel];
            return headerView;
        }
        default:
            return nil;
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    KSDebugRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[KSDebugRequestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    KSDebugRequestModel *model;
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:{
            model = self.requestArray[indexPath.row];
        }
            break;
        case KSDebugRequestListShowTypeSortByVC: {
            KSDebugRequestVCModel *VCModel = self.sortedRequestArray[indexPath.section];
            model = VCModel.requestArray[indexPath.row];
        }
        default:
            break;
    }
    cell.requestModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KSDebugRequestModel *model;
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault:{
            model = self.requestArray[indexPath.row];
        }
            break;
        case KSDebugRequestListShowTypeSortByVC: {
            KSDebugRequestVCModel *VCModel = self.sortedRequestArray[indexPath.section];
            model = VCModel.requestArray[indexPath.row];
        }
        default:
            break;
    }
    !self.selectedRequestModelBlock?:self.selectedRequestModelBlock(model);
}

@end
