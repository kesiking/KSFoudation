//
//  EHAboutViewController.m
//  eHome
//
//  Created by xtq on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSAboutViewController.h"
#import "HSExemptionDescriptionViewController.h"
#import "UMSocial.h"
#import "EHSocializedSharedMacro.h"

#define kHeaderViewHeight   270
#define kCellHeight         50

@interface HSAboutViewController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HSAboutViewController
{
    GroupedTableView *_tableView;
    UIView *_headView;
}

#pragma mark - Life Circle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"关于";
    self.view.backgroundColor =EHBgcor1;
    [self.view addSubview:[self headView]];
    [self initTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    NSArray *titleArray = @[@"免责说明",@"意见反馈"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = EHFont2;
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TBOpenURLFromTarget(@"HSExemptionDescriptionViewController", self);
    }
    else {
        TBOpenURLFromTarget(@"HSFeedBackViewController", self);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - Getters And Setters


- (void)initTableView{
    if (!_tableView) {
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(10, kHeaderViewHeight, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame) - kHeaderViewHeight) style:UITableViewStylePlain];
        EHLogInfo(@"table height = %f",_tableView.frame.size.height);
        _tableView.backgroundColor = EHBgcor1;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        CGFloat height = CGRectGetHeight(_tableView.frame) / 2.0 < kCellHeight?CGRectGetHeight(_tableView.frame) / 2.0:kCellHeight;
        _tableView.rowHeight = height;
        _tableView.sectionHeaderHeight = 100;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:_tableView];
    }
    return;
}

- (UIView *)headView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderViewHeight)];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.center = CGPointMake(SCREEN_WIDTH/2, 100);
    
    UILabel *descriptionLogoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 15, CGRectGetWidth(_headView.frame), 20)];
    descriptionLogoLabel.text = [HSDeviceDataCenter appName];
    descriptionLogoLabel.font = EHFont5;
    descriptionLogoLabel.textColor = EHCor5;
    descriptionLogoLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptionLogoLabel.frame) + 10, CGRectGetWidth(_headView.frame), 15)];
    versionLabel.textColor = EHCor5;
    versionLabel.font = EHFont5;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [versionLabel sizeToFit];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // build
    NSString *build_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"v%@ (Build%@)",app_Version, build_Version];
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(CGRectGetWidth(_headView.frame) / 2.0, CGRectGetMaxY(descriptionLogoLabel.frame) + 5 + CGRectGetHeight(versionLabel.frame) / 2.0);
    
    UILabel *descriptionCmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX * 3, CGRectGetMaxY(versionLabel.frame) + 10, CGRectGetWidth(_headView.frame) - kSpaceX * 6, 40)];
    descriptionCmpLabel.text = @"中移（杭州）信息技术有限公司";
    descriptionCmpLabel.textColor = EHCor5;
    descriptionCmpLabel.font = EHFont5;
    descriptionCmpLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionCmpLabel.numberOfLines = 0;
    descriptionCmpLabel.textAlignment = NSTextAlignmentCenter;
    [descriptionCmpLabel sizeToFit];
    descriptionCmpLabel.center = CGPointMake(CGRectGetWidth(_headView.frame) / 2.0, CGRectGetMaxY(versionLabel.frame) + 15 + CGRectGetHeight(descriptionCmpLabel.frame) / 2.0);

    [_headView addSubview:logoImageView];
    [_headView addSubview:descriptionLogoLabel];
    [_headView addSubview:versionLabel];
    [_headView addSubview:descriptionCmpLabel];
    return _headView;
}

@end
