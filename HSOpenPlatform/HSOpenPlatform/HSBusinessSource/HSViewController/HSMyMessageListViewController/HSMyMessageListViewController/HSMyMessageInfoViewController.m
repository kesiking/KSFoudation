//
//  HSMyMessageInfoViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMyMessageInfoViewController.h"
#import "HSMyMessageListView.h"

@interface HSMyMessageInfoViewController ()

@property (nonatomic,strong) HSMyMessageListView        *messageListView;

@property (nonatomic,strong) UIBarButtonItem            *editListButtonItem;

@property (nonatomic,strong) UIBarButtonItem            *finishListButtonItem;

@end

@implementation HSMyMessageInfoViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMessageNavBarViews];
    [self.view addSubview:self.messageListView];
    
    self.editListButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editStart:)];
    self.finishListButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(editFinish:)];
    self.navigationItem.rightBarButtonItem = self.editListButtonItem;
    
}

-(void)initMessageNavBarViews{
    self.title = @"我的消息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editStart:(UIBarButtonItem*)button{
    [self.messageListView setIsTableViewEdit:!self.messageListView.isTableViewEdit];
    self.navigationItem.rightBarButtonItem = self.finishListButtonItem;
}

- (void)editFinish:(UIBarButtonItem*)button{
    [self.messageListView setIsTableViewEdit:!self.messageListView.isTableViewEdit];
    self.navigationItem.rightBarButtonItem = self.editListButtonItem;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载    activityInfoListView

-(HSMyMessageListView *)messageListView{
    if (_messageListView == nil) {
        _messageListView = [[HSMyMessageListView alloc] initWithFrame:self.view.bounds];
    }
    return _messageListView;
}

@end
