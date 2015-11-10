//
//  EHUserPicFromCameraViewController.m
//  eHome
//
//  Created by xtq on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUserPicFromCameraViewController.h"

@interface EHUserPicFromCameraViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation EHUserPicFromCameraViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self bgImageView]];
}

#pragma mark - Events Response
- (void)showCamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"无法打开照相机,请检查！");
        [WeAppToast toast:@"无法打开照相机,请检查！"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"didFinishPickingMediaWithInfo");
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    __block NSData *imageData = UIImageJPEGRepresentation(pickedImage, 1);
    WEAKSELF
    [picker dismissViewControllerAnimated:YES completion:^{
        STRONGSELF
        [strongSelf dismissViewControllerAnimated:NO completion:^{
            strongSelf.finishSelectedImageBlock(imageData);
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    typeof(self) __weak weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakself dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Helper Functions
/**
 *  全屏截图
 */
- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Getters And Setters
//设置跟转场前视图一样的背景视图
- (UIImageView *)bgImageView{
   UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [self screenshot];
    return bgImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
