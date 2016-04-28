//
//  HSFamilyAppIntroViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSFamilyAppIntroViewController.h"
#import "HSFamilyAppIntroCustomViewController.h"
#import "HSApplicationIntroModel.h"
#import "HSAppSystemModel.h"

@interface HSFamilyAppIntroViewController ()

@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) HSApplicationIntroModel *appIntro;

@end

@implementation HSFamilyAppIntroViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.appIntro = [nativeParams objectForKey:@"appIntro"];
        self.title = self.appIntro.appName;
    }
    return self;
}

- (BOOL)needToolbarItems{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *linvView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 0.5)];
    [linvView setBackgroundColor:RGB(0xda, 0xda, 0xda)];
    [self.view addSubview:linvView];
    [self.view addSubview:self.bottomButton];

}

- (void)bottomButtonClick:(id)sender {
    NSArray *appSysArray = self.appIntro.appSys;
    HSAppSystemModel *appSystemModel = appSysArray[0];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appSystemModel.downUrl]];
}

-(UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.width - 315*SCREEN_SCALE)/2, self.view.height - (10 + 40 )*SCREEN_SCALE,315*SCREEN_SCALE , 40*SCREEN_SCALE)];
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.cornerRadius = 6.;
        _bottomButton.titleLabel.font = EHFont2;
        _bottomButton.titleLabel.textColor = EHCor1;
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"button_点击"] forState:UIControlStateHighlighted];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"button_正常"] forState:UIControlStateNormal];
        
        [_bottomButton setTitle:@"下载APP" forState:UIControlStateNormal];

        [_bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _bottomButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
