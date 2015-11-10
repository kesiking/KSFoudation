//
//  EHPhotoPlayViewController.m
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHPhotoPlayViewController.h"
#import "EHPhotoBrowserViewController.h"
#import "EHImageMagicMoveInverseTransition.h"
#import "EHImageClipView.h"

@interface EHPhotoPlayViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>

@end

@implementation EHPhotoPlayViewController
{
    UIScrollView *_sv;
    CGRect _imageViewRect;
    BOOL _isBarHidden;
    EHImageClipView *_imageClipView;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"头像设置";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;

    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnClick:)];
    self.navigationItem.rightBarButtonItem = sureItem;
    
    _isBarHidden = NO;
    
    [self.view addSubview:[self bgView]];
    [self.view addSubview:[self scrollView]];
    [self.view addSubview:[self imageClipView]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        _imageClipView.alpha = 1;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _imageClipView.alpha = 0;
    }];
}

#pragma mark - Events Reponse
- (void)sureBtnClick:(id)sender{
    NSLog(@"sureBtnClick");
    WEAKSELF
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = UIImageJPEGRepresentation([_imageClipView imageClipped], 1);
        STRONGSELF
        strongSelf.finishSelectedImageBlock(imageData);
    }];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [self.navigationController setNavigationBarHidden:!_isBarHidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:!_isBarHidden withAnimation:UIStatusBarAnimationSlide];
    _isBarHidden = !_isBarHidden;
}

#pragma mark - Common Methods
/**
 *  双击缩放
 */
- (void)doubleTap:(UIGestureRecognizer *)gesture
{
    float newScale;
    if (_sv.zoomScale != _sv.maximumZoomScale) {
        newScale = _sv.maximumZoomScale;
    }
    else{
        newScale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [_sv zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =_sv.frame.size.height / scale;
    zoomRect.size.width  =_sv.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[EHPhotoBrowserViewController class]]) {
        return [[EHImageMagicMoveInverseTransition alloc] init];
    }
    else {
        return nil;
    }
}

#pragma mark - UIScrollViewDelegate
/**
 *  设置缩放视图
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

/**
 *  使图片缩放后居中显示
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - Getters And Setters
-(UIScrollView *)scrollView{
    if (!_sv) {
        CGFloat length = MIN(self.view.frame.size.width, self.view.frame.size.height);
        CGFloat x = (self.view.frame.size.width - length) / 2.0;
        CGFloat y = (self.view.frame.size.height - length) / 2.0;
        CGRect frame = CGRectMake(x, y, length, length);
        
        _sv = [[UIScrollView alloc]initWithFrame:frame];
        _sv.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        _sv.delegate = self;
        _sv.contentOffset = CGPointMake(0, 0);
        _sv.contentSize = _sv.bounds.size;
        _sv.showsHorizontalScrollIndicator = NO;
        _sv.showsVerticalScrollIndicator = NO;
        _sv.minimumZoomScale = 0.5;
        _sv.maximumZoomScale = 2.5;
        _sv.clipsToBounds = NO;
        [_sv addSubview:self.imageView];
        
        _sv.contentSize = self.imageView.size;

        CGFloat offset = (_sv.bounds.size.height < _sv.contentSize.height)?
        (_sv.contentSize.height - _sv.bounds.size.height) * 0.5 : 0.0;
        _sv.contentOffset = CGPointMake(0, offset);

        //图片位置居中
        CGFloat offsetX = (_sv.bounds.size.width > _sv.contentSize.width)?
        (_sv.bounds.size.width - _sv.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (_sv.bounds.size.height > _sv.contentSize.height)?
        (_sv.bounds.size.height - _sv.contentSize.height) * 0.5 : 0.0;
        _imageView.center = CGPointMake(_sv.contentSize.width * 0.5 + offsetX,
                                        _sv.contentSize.height * 0.5 + offsetY);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_sv addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_sv addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return _sv;
}

/**
 *  在自定义转场时应考虑到转场前的原UIImageView的显示模式是ScaleAspectFill的，为呈现转场后的ScaleAspectFit的模式效果应进行宽高的处理
 */
- (UIImageView *)imageView{
    if (!_imageView) {
        //设置imageView的宽高
        CGFloat imageViewWidth;
        CGFloat imageViewHeight;
        if (self.bigImage.size.width / self.bigImage.size.height <= self.view.frame.size.width / self.view.frame.size.height) {
            imageViewWidth = self.bigImage.size.width / self.bigImage.size.height * self.view.frame.size.height;
            imageViewHeight = self.view.frame.size.height;
        }
        else {
            imageViewHeight = self.bigImage.size.height/self.bigImage.size.width * self.view.frame.size.width;
            imageViewWidth = self.view.frame.size.width;
        }
        CGRect imageViewRect = CGRectMake((self.view.frame.size.width - imageViewWidth) / 2.0,0, imageViewWidth, imageViewHeight);
        
        _imageView = [[UIImageView alloc]initWithImage:self.bigImage];
        _imageView.frame = imageViewRect;
    }
    return _imageView;
}

//防止视图弹跳Bug
- (UIView *)bgView{
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    return bgView;
}

- (UIView *)imageClipView{
    if (!_imageClipView) {
        _imageClipView = [[EHImageClipView alloc]initWithFrame:self.view.bounds];
        _imageClipView.alpha = 0;
    }
    return _imageClipView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
