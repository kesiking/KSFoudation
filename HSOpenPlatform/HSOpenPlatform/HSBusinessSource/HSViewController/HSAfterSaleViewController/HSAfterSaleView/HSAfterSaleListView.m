//
//  HSAfterSaleListView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleListView.h"

#define kHSAfterSaleViewHeaderHeight     caculateNumber(44.0)
#define kHSAfterSaleViewFooterHeight     caculateNumber(15)
#define kHSNationalAfterSaleCellHeight   caculateNumber(88)
#define kHSLocalAfterSaleCellHeight      caculateNumber(110)

@interface HSAfterSaleListView ()


@end

@implementation HSAfterSaleListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    self.needRefreshHeader = YES;
    self.needLoadMoreFooter = YES;
    
    if (self) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins: UIEdgeInsetsZero];
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1?self.dataArray.count:(!self.nationalAfterSaleModel?0:1));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HSNationalAfterSaleCell *cell = [[HSNationalAfterSaleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setModel:self.nationalAfterSaleModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString *cellID = @"cellID";
        HSHomeServicLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HSHomeServicLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        HSMapPoiModel *poiModel = self.dataArray[indexPath.row];
        cell.model = poiModel;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return kHSNationalAfterSaleCellHeight;
            break;
        default:
            return kHSLocalAfterSaleCellHeight;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kHSAfterSaleViewFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHSAfterSaleViewHeaderHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = EH_cor1;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = EHLinecor1.CGColor;
    layer.frame = CGRectMake(0, 0, tableView.width, 0.5);
    [view.layer addSublayer:layer];
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(caculateNumber(15), 0, CGRectGetWidth(tableView.frame), kHSAfterSaleViewHeaderHeight)];
    titlelabel.font = EHFont2;
    titlelabel.textColor = EHCor5;
    
    if (section == 0) {
        titlelabel.text = @"全国统一售后中心";
    }
    else if (section == 1) {
        titlelabel.text = @"本地售后网点";
    }
    
    [view addSubview:titlelabel];
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
