//
//  HSFamilyAppIntroViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSFamilyAppIntroViewController.h"

@interface HSFamilyAppIntroViewController ()

@property (strong, nonatomic) NSString *H5url;
@property (strong, nonatomic) UIButton *bottomButton;
@property (assign, nonatomic) BOOL isAppInstalled;
@property (strong, nonatomic) NSURL *appURLScheme;
//@property (strong, nonatomic) NSString *appTitle;

@end

@implementation HSFamilyAppIntroViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.H5url = [nativeParams objectForKey:WEB_REQUEST_URL_ADDRESS_KEY];
        self.title = [nativeParams objectForKey:WEB_VIEW_TITLE_KEY];
        self.appURLScheme = [NSURL URLWithString:[nativeParams objectForKey:@"appIOSURLScheme"]];
        self.isAppInstalled = [[UIApplication sharedApplication] canOpenURL:self.appURLScheme];

        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 60 - 44);
    }
    return self;
}

- (BOOL)needToolbarItems{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *linvView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - 44, self.view.frame.size.width, 0.5)];
    [linvView setBackgroundColor:RGB(0xda, 0xda, 0xda)];
    [self.view addSubview:linvView];
    [self.view addSubview:self.bottomButton];

}

- (void)bottomButtonClick:(id)sender {
    if (self.isAppInstalled) {
        [[UIApplication sharedApplication] openURL:self.appURLScheme];
    }
    else{
        //跳转下载链接
    }}

-(UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.width - 270*SCREEN_SCALE)/2, self.view.height - (10 + 44),270*SCREEN_SCALE , 40)];
        //_bottomButton.backgroundColor = RGB(0x23, 0x74, 0xfa);
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.cornerRadius = 6.;
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"btn_Join_h"] forState:UIControlStateHighlighted];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"btn_Join_n"] forState:UIControlStateNormal];
        if (self.isAppInstalled) {
            [_bottomButton setTitle:@"打开APP" forState:UIControlStateNormal];
        }
        else{
            [_bottomButton setTitle:@"下载APP" forState:UIControlStateNormal];
        }
        [_bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        - (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;                     // default is nil. title is assumed to be single line
//        - (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state
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
