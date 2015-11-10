//
//  EHAppQRImageViewController.m
//  eHome
//
//  Created by xtq on 15/7/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSAppQRImageViewController.h"
#import "EHSocializedSharedMacro.h"
#import "MWQREncode.h"

#define QRIMAGE_X_MARGIN 60
#define QRIMAGE_Y_MARGIN 180

@interface HSAppQRImageViewController ()

@property (nonatomic, strong)   UILabel         *appNameLabel;

@property (nonatomic, strong)   UILabel         *appRecommentLabel;

@property (nonatomic, strong)   UIImageView     *appQRImageView;

@end

@implementation HSAppQRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码";
    self.view.backgroundColor = EHBgcor1;
    
    [self.view addSubview:self.appNameLabel];
    [self.view addSubview:self.appQRImageView];
    [self.appRecommentLabel setText:@"下载我推荐的应用！"];
}

- (UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
        _appNameLabel.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMinY(self.view.frame) + 100);
        _appNameLabel.text = kHS_APP_NAME;
        _appNameLabel.font = EH_font1;
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.backgroundColor = EHBgcor1;
    }
    return _appNameLabel;
}

KSPropertyInitLabelView(appRecommentLabel,{
    _appRecommentLabel.font = EH_font6;
    _appRecommentLabel.backgroundColor = EHBgcor1;
    [_appRecommentLabel setFrame:CGRectMake(8, 8, self.view.width - 8 * 2, 20)];
})

- (UIImageView *)appQRImageView{
    if (!_appQRImageView) {
        
        CGFloat imageViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - QRIMAGE_X_MARGIN * 2;
        UIImage *appQRImage = [MWQREncode qrImageForString:kHS_WEBSITE_URL imageSize:imageViewWidth LogoImage:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME]];

        _appQRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
        _appQRImageView.center = CGPointMake(CGRectGetMidX(self.view.frame), self.appNameLabel.bottom + imageViewWidth/2);
        _appQRImageView.image = appQRImage;
        _appQRImageView.backgroundColor = EHBgcor1;
    }
    return _appQRImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
