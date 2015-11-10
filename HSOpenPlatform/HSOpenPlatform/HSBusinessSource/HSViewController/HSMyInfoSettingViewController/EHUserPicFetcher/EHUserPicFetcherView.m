//
//  EHUserPicFetcherView.m
//  eHome
//
//  Created by xtq on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUserPicFetcherView.h"
#import "EHUserPicFromCameraViewController.h"
#import "EHUserPicFromPhotosViewController.h"

#define kBtnHeight 50
#define kSubViewHeight 20
#define kSubViewWidth 25
#define kSpace 10
#define kHudViewHeight (kBtnHeight * 4 + kSpace *2)
#define kHudViewWidth (CGRectGetWidth(self.frame) - kSpace * 2)

typedef NS_ENUM(NSInteger, kButtonTag) {
    kButtonTagCamera= 1,
    kButtonTagPhoto,
    kButtonTagCancle,
};


@interface EHUserPicFetcherView()<UIImagePickerControllerDelegate>
@end

@implementation EHUserPicFetcherView
{
    UIView *_hudView;   //弹框视图
    id _target;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    }
    return self;
}

- (void)showFromTarget:(id)target{
    _target = target;
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    self.frame = window.bounds;
    
    [window addSubview:self];
    [self addSubview:[self hudView]];
    [self appearAnimated];
}

#pragma mark - Helper Functions
/**
 *  显示动画
 */
- (void)appearAnimated{
    
    _hudView.layer.transform = CATransform3DMakeTranslation(0, kHudViewHeight, 0);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _hudView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
    }];
}

/**
 *  消失动画并作出选择
 */
- (void)disappearAnimatedWithTag:(kButtonTag)tag{

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _hudView.layer.transform = CATransform3DMakeTranslation(0, kHudViewHeight, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        switch (tag) {
            case kButtonTagCamera:
                [self showCamera];
                break;
            case kButtonTagPhoto:
                [self showPhotos];
                break;
            default:
                break;
        }
    }];
}

- (void)showCamera{
    EHUserPicFromCameraViewController *cvc = [[EHUserPicFromCameraViewController alloc]init];
    cvc.finishSelectedImageBlock = self.finishSelectedImageBlock;
    [_target presentViewController:cvc animated:NO completion:^{
        [cvc showCamera];
    }];
}

- (void)showPhotos{
    EHUserPicFromPhotosViewController *pvc = [[EHUserPicFromPhotosViewController alloc]init];
    pvc.finishSelectedImageBlock = self.finishSelectedImageBlock;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:pvc];
    nvc.navigationBar.translucent = NO;
    if([nvc.navigationBar respondsToSelector:@selector(barTintColor)]){
        nvc.navigationBar.barTintColor = UINAVIGATIONBAR_COLOR;
    }
    if([nvc.navigationBar respondsToSelector:@selector(tintColor)]){
        nvc.navigationBar.tintColor  =   UINAVIGATIONBAR_TITLE_COLOR;
    }
    [nvc.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    nvc.navigationBar.shadowImage = [[UIImage alloc]init];
    // 修改navbar title颜色
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               UINAVIGATIONBAR_TITLE_COLOR, NSForegroundColorAttributeName,
                                               [UIFont boldSystemFontOfSize:UINAVIGATIONBAR_TITLE_SIZE], NSFontAttributeName,nil];
    
    [nvc.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    [_target presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Events Response
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self disappearAnimatedWithTag:kButtonTagCancle];
}

/**
 *  相机
 */
- (void)cameraButtonClick:(id)sender{
    [self disappearAnimatedWithTag:kButtonTagCamera];
}

/**
 *  相册
 */
- (void)photoButtonClick:(id)sender{
    [self disappearAnimatedWithTag:kButtonTagPhoto];
}

/**
 *  取消
 */
- (void)cancleButtonClick:(id)sender{
    [self disappearAnimatedWithTag:kButtonTagCancle];
}


#pragma mark - Getters And Setters
- (UIView *)hudView{
    _hudView = [[UIView alloc]initWithFrame:CGRectMake(kSpace, CGRectGetHeight(self.frame) - kHudViewHeight, kHudViewWidth, kHudViewHeight)];
    _hudView.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHudViewWidth, kBtnHeight * 3)];
    topView.layer.cornerRadius = 4;
    topView.clipsToBounds = YES;
    [topView addSubview:[self cameraButton]];
    [topView addSubview:[self photoButton]];
    [topView addSubview:[self titleButton]];
    [_hudView addSubview:topView];
    [_hudView addSubview:[self cancleButton]];
    return _hudView;
}

- (UIButton *)cameraButton{
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kBtnHeight, kHudViewWidth, kBtnHeight)];
    cameraButton.backgroundColor = [UIColor whiteColor];
    [cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *cameraImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_camera"]];
    cameraImv.frame = CGRectMake(kHudViewWidth / 2.0 - kSubViewWidth - kSpace / 2.0, (kBtnHeight - kSubViewHeight) / 2.0, kSubViewWidth,kSubViewHeight);
    
    UILabel *cameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHudViewWidth / 2.0 + kSpace / 2.0, (kBtnHeight - kSubViewHeight) / 2.0, 100, kSubViewHeight)];
    cameraLabel.text = @"拍照";
    cameraLabel.textColor = EH_cor4;
    cameraLabel.font = EH_font2;
    cameraLabel.textAlignment = NSTextAlignmentLeft;
    
    [cameraButton addSubview:cameraImv];
    [cameraButton addSubview:cameraLabel];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, kBtnHeight - 0.5, CGRectGetWidth(cameraButton.frame), 0.5)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = EH_linecor1.CGColor;
    [cameraButton.layer addSublayer:shapeLayer];
    
    return cameraButton;
}

- (UIButton *)photoButton{
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kBtnHeight*2, kHudViewWidth, kBtnHeight)];
    photoButton.backgroundColor = [UIColor whiteColor];
    [photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *photoImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_picture"]];
    photoImv.frame = CGRectMake(kHudViewWidth / 2.0 - kSubViewWidth - kSpace / 2.0, (kBtnHeight - kSubViewHeight) / 2.0, kSubViewWidth,kSubViewHeight);
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHudViewWidth / 2.0 + kSpace / 2.0, (kBtnHeight - kSubViewHeight) / 2.0, 100, kSubViewHeight)];
    photoLabel.text = @"相册";
    photoLabel.font = EH_font2;
    photoLabel.textColor = EH_cor4;
    photoLabel.textAlignment = NSTextAlignmentLeft;
    [photoButton addSubview:photoImv];
    [photoButton addSubview:photoLabel];
    
    return photoButton;
}


- (UIButton *)titleButton{
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kHudViewWidth, kBtnHeight)];
    titleButton.backgroundColor = [UIColor whiteColor];
    UILabel *resetLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (kBtnHeight - kSubViewHeight) / 2.0, kHudViewWidth, kSubViewHeight)];
    resetLabel.text = @"头像设置";
    resetLabel.font = EH_font2;
    resetLabel.textColor = EH_cor4;
    resetLabel.textAlignment = NSTextAlignmentCenter;

    [titleButton addSubview:resetLabel];
    
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, kBtnHeight - 0.5, CGRectGetWidth(titleButton.frame), 0.5);
    lineLayer.backgroundColor = EH_linecor1.CGColor;;
    [titleButton.layer addSublayer:lineLayer];
    
    return titleButton;
}



- (UIButton *)cancleButton{
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kHudViewHeight - kBtnHeight - kSpace, kHudViewWidth, kBtnHeight)];
    cancleButton.backgroundColor = [UIColor whiteColor];
    cancleButton.layer.cornerRadius = 4;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = EH_font2;
    [cancleButton setTitleColor:EH_cor4 forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cancleButton;
}


@end
