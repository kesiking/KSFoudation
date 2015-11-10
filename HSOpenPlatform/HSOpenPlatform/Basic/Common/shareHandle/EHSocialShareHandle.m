//
//  EHSocialShareHandle.m
//  test-7.14-share
//
//  Created by xtq on 15/7/14.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHSocialShareHandle.h"
#import "NSString+StringSize.h"

#define kColumn 4           //列数
#define kSideSpaceX 40 / 2.0
#define kViewSpaceX 27 / 2.0
#define kViewSpaceY 75 / 2.0

#define kViewTag 100

@interface EHSocialShareHandle (){
    UIView *_bgView;
    EHSocialShareView *_shareView;
    NSTimeInterval _duration;
}
@property (nonatomic, strong) EHSocialShareView         *shareView;

@end

@implementation EHSocialShareHandle


- (instancetype)init{
    self = [super init];
    if (self) {
        _duration = 0.3;
    }
    return self;
}

+(EHSocialShareHandle *)sharedManager{
    static dispatch_once_t predicate;
    static EHSocialShareHandle * sharedManager;
    dispatch_once(&predicate, ^{
        sharedManager=[[EHSocialShareHandle alloc] init];
    });
    return sharedManager;
}

+ (void)presentWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image FromTarget:(id)target{
    
    [[EHSocialShareHandle sharedManager] showWithTypeArray:array Title:title Image:image FromTarget:target];
}

+ (void)presentWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image presentedController:(UIViewController*)presentedController{
    typeof(presentedController) __weak __block weakVC = presentedController;
    [self presentWithTypeArray:array Title:title Image:image shareTitleAndImageBlock:^(NSInteger type, NSString *title, UIImage *image) {
        //分享消息类型为默认的图文分享带链接
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
        //分享结果处理代码块
        void (^sharedResponseManageBlock)(UMSocialResponseEntity *response) = ^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                EHLogInfo(@"分享成功！");
                [WeAppToast toast:@"分享成功！"];
            }
            else {
                EHLogInfo(@"分享失败！");
                [WeAppToast toast:@"分享失败！"];
            }
        };
        
        switch (type) {
            case EHShareTypeWechatSession:
            {
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:title image:image location:nil urlResource:nil presentedController:weakVC completion:^(UMSocialResponseEntity *response){
                    sharedResponseManageBlock(response);
                }];
            }
                break;
                
            case EHShareTypeWechatTimeline:
            {
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:title image:image location:nil urlResource:nil presentedController:weakVC completion:^(UMSocialResponseEntity *response){
                    sharedResponseManageBlock(response);
                }];
            }
                break;
                
            case EHShareTypeQQ:
            {
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:title image:image location:nil urlResource:nil presentedController:weakVC completion:^(UMSocialResponseEntity *response){
                    sharedResponseManageBlock(response);
                }];
            }
                break;
                
            case EHShareTypeWeibo:
            {
                [[UMSocialControllerService defaultControllerService] setShareText:title shareImage:image socialUIDelegate:(id)weakVC];        //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(weakVC,[UMSocialControllerService defaultControllerService],YES);
                
            }
                break;
                
            case EHShareTypeSms:
            {
                
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:title image:image location:nil urlResource:nil presentedController:weakVC completion:^(UMSocialResponseEntity *response){
                    sharedResponseManageBlock(response);
                }];
                
            }
                break;
            case EHShareTypeQRCode:
            {
                EHLogInfo(@"二维码分享按钮");
                TBOpenURLFromTarget(@"HSAppQRImageViewController", weakVC);
            }
                break;
                
            default:
                break;
        }
    }];
}

+ (void)presentWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image shareTitleAndImageBlock:(void (^)(NSInteger type, NSString *title, UIImage *image))shareTitleAndImageBlock{
    [self presentWithTypeArray:array Title:title Image:image FromTarget:nil];
    [[EHSocialShareHandle sharedManager].shareView setShareTitleAndImageBlock:shareTitleAndImageBlock];
}

- (void)showWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image FromTarget:(id)target{
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    if (_bgView != nil) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
    _bgView = [[UIView alloc]initWithFrame:window.bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_bgView addGestureRecognizer:tap];
    [window addSubview:_bgView];
    
    if (_shareView != nil) {
        [_shareView removeFromSuperview];
        _shareView.delegate = nil;
        _shareView.shareTitleAndImageBlock = nil;
        _shareView = nil;
    }
    
    _shareView = [[EHSocialShareView alloc]initWithTypeArray:array Title:title Image:image InView:_bgView FromTarget:target];
    typeof(self) __weak weakSelf = self;
    __block NSTimeInterval delay = _duration;
    _shareView.finishSelectedBlock = ^(){
        [weakSelf hide];
        return delay;
    };
    
    _shareView.layer.transform = CATransform3DMakeTranslation(0, CGRectGetHeight(_shareView.frame), 0);
    [UIView animateWithDuration:_duration animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _shareView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:_duration animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _shareView.layer.transform = CATransform3DMakeTranslation(0, CGRectGetHeight(_shareView.frame), 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_shareView removeFromSuperview];
        _bgView = nil;
        _shareView.delegate = nil;
        _shareView.shareTitleAndImageBlock = nil;
        _shareView = nil;
    }];
}

- (void)tap:(id)gesture{
    [self hide];
}


@end





@interface EHSocialShareView()

@property (nonatomic, strong)NSString *shareTitle;

@property (nonatomic, strong)UIImage *shareImage;

@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic, strong)NSArray *imageArray;


@end

@implementation EHSocialShareView


- (instancetype)initWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image InView:(UIView *)view FromTarget:(id)target{
    self = [super init];
    if (self) {
        self.backgroundColor = EHBgcor1;
        self.frame = view.bounds;
        [view addSubview:self];
        
        self.typeArray = array;
        self.delegate = target;
        self.shareTitle = title;
        self.shareImage = image;
        
        [self configUI];
    }
    return self;
}

- (instancetype)initWithTypeArray:(NSArray *)array Title:(NSString *)title Image:(UIImage *)image InView:(UIView *)view shareTitleAndImageBlock:(shareTitleAndImageBlock)shareTitleAndImageBlock{
    self = [self initWithTypeArray:array Title:title Image:image InView:view FromTarget:nil];
    if (self) {
        self.shareTitleAndImageBlock = shareTitleAndImageBlock;
    }
    return self;
}


#pragma mark - Events Response
- (void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *imv = (UIImageView *)tap.view;
    if (self.finishSelectedBlock) {
        NSInteger delay =  self.finishSelectedBlock();
        [self performSelector:@selector(selectTag:) withObject:@(imv.tag - kViewTag) afterDelay:delay];
    }
    else {
        [self performSelector:@selector(selectTag:) withObject:@(imv.tag - kViewTag) afterDelay:0];
    }
    
}

- (void)selectTag:(NSNumber *)tag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWithType:Title:Image:)]) {
        [self.delegate shareWithType:[tag integerValue] Title:self.shareTitle Image:self.shareImage];
    }
    if (self.shareTitleAndImageBlock) {
        self.shareTitleAndImageBlock([tag integerValue], self.shareTitle, self.shareImage);
    }
}

#pragma mark - Getters And Setters
- (void)configUI{
    CGFloat imageWidth = (CGRectGetWidth(self.frame) - (kSideSpaceX * 2 + kViewSpaceX * (kColumn - 1))) / ((CGFloat)kColumn);
    CGFloat imageHeight = imageWidth;
    
    CGFloat labelWidth = imageWidth;
    CGFloat labelHeight = [self.titleArray[0] sizeWithFontSize:EH_siz5 Width:imageWidth].height;
    
    CGFloat selfHeight = (15 + imageWidth + 11 + labelHeight) * ((self.typeArray.count - 1) / kColumn + 1) + 15;
    
    self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame) - selfHeight, CGRectGetWidth(self.superview.frame), selfHeight);
    
    for (int i = 0 ; i < self.typeArray.count; i++) {
        
        NSString *title = self.typeArray[i];
        NSInteger index = [self.titleArray indexOfObject:title];
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(kSideSpaceX + (imageWidth + kViewSpaceX)* (i % kColumn), 15 + (imageHeight + 11 + labelHeight + 15) * (i/kColumn), imageWidth, imageHeight) ];
        imv.contentMode = UIViewContentModeScaleToFill;
        if ([self.imageArray count] > index) {
            [imv setImage:self.imageArray[index]];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imv addGestureRecognizer:tap];
        imv.userInteractionEnabled = YES;
        imv.tag = kViewTag + index;
        [self addSubview:imv];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imv.frame.origin.x, CGRectGetMaxY(imv.frame) + 11, labelWidth, labelHeight)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:EH_siz5];
        label.textColor = EHCor5;
        [self addSubview:label];
    }
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToQQ,EHShareToSina,EHShareToSms,EHShareToQRCode];
    }
    return _titleArray;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        UIImage *wechatSessionImage = [UIImage imageNamed:@"public_icon_share_wechat"]?:HSDefaultPlaceHoldImage;
        UIImage *wechatTimelineImage = [UIImage imageNamed:@"public_icon_share_circleoffriends"]?:HSDefaultPlaceHoldImage;
        UIImage *QQImage = [UIImage imageNamed:@"public_icon_share_QQ"]?:HSDefaultPlaceHoldImage;
        UIImage *sinaImage = [UIImage imageNamed:@"ico_share_sina"]?:HSDefaultPlaceHoldImage;
        UIImage *smsImage = [UIImage imageNamed:@"public_icon_share_message"]?:HSDefaultPlaceHoldImage;
        UIImage *QRCodeImage = [UIImage imageNamed:@"public_icon_share_twodimensioncode"]?:HSDefaultPlaceHoldImage;
        _imageArray = @[wechatSessionImage,wechatTimelineImage,QQImage,sinaImage,smsImage,QRCodeImage];
    }
    return _imageArray;
}

@end
