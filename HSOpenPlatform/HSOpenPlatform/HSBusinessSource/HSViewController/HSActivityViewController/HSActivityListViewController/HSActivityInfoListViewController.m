//
//  HSActivityInfoListViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoListViewController.h"
#import "HSActivityInfoListView.h"

@interface HSActivityInfoListViewController ()

@property (nonatomic, strong) HSActivityInfoListView       *activityInfoListView;

@end

@implementation HSActivityInfoListViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initActivityNavBarViews];
    [self.view addSubview:self.activityInfoListView];
}

-(void)initActivityNavBarViews{
    self.title = @"最新活动";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载    activityInfoListView

-(HSActivityInfoListView *)activityInfoListView{
    if (_activityInfoListView == nil) {
        _activityInfoListView = [[HSActivityInfoListView alloc] initWithFrame:self.view.bounds];
    }
    return _activityInfoListView;
}

@end
