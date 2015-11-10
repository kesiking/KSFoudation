//
//  EHMyInfoViewController.m
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMyInfoViewController.h"
#import "KSLoginComponentItem.h"
#import "EHUserPicFetcherView.h"
#import "EHUploadUserPicService.h"
#import "EHModifyUserPicService.h"
#import "UIImageView+WebCache.h"
#import "EHBigUserPicShowController.h"
#import "EHLoadingHud.h"
#import "EHModifyNickNameViewController.h"
#import "RMActionController.h"

#define kCellHeight     50
#define kHeaderViewHeight 30

@interface EHMyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EHMyInfoViewController
{
    GroupedTableView *_tableView;
    UIImageView *_headImageView;
    EHUploadUserPicService *_uploadHeadImageService;
    EHModifyUserPicService *_modifyUserPicService;
    EHLoadingHud *_loadingHud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信息";
    
    [self initTableView];
    [self.view addSubview:[self logOutButton]];
    _headImageView = [self headImageView];
    _loadingHud = [[EHLoadingHud alloc]init];
}

#pragma mark - Events Response
/**
 *  头像点击放大查看
 */
- (void)headImageViewTap:(UITapGestureRecognizer *)tap{
    EHBigUserPicShowController *bigUserPicShowController = [[EHBigUserPicShowController alloc]init];
    bigUserPicShowController.fromView = (UIImageView *)tap.view;
    [self presentViewController:bigUserPicShowController animated:NO completion:^{}];
}

- (void)logOutButtonClick:(id)sender{
    [self showLogOutAlert];
}

- (void)showLogOutAlert
{
    RMActionController* unbindAlert = [RMActionController actionControllerWithStyle:RMActionControllerStyleWhite];
    unbindAlert.title = @"退出账号后，您将接受不到app的消息提醒";
    unbindAlert.titleColor = EH_cor5;
    unbindAlert.titleFont = EH_font6;
    
    WEAKSELF
    RMAction *unbindAction = [RMAction actionWithTitle:@"退出账号" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        
        STRONGSELF
        [KSAuthenticationCenter logoutWithCompleteBolck:^{
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            [params setObject:@YES forKey:kHSOPTabHomeNeedLogin];
            NSDictionary* queryParams = nil;
            if (IOS_VERSION < 8.0) {
                queryParams = @{ACTION_ANIMATION_KEY:@(false)};
            }
            TBOpenURLFromTargetWithNativeParams(tabbarURL(kHSOPTabHome), strongSelf,queryParams, params);
        }];
    }];
    
    unbindAction.titleColor = EH_cor7;
    unbindAction.titleFont = EH_font2;
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    cancelAction.titleColor = EH_cor4;
    cancelAction.titleFont = EH_font2;
    
    [unbindAlert addAction:unbindAction];
    [unbindAlert addAction:cancelAction];
    
    unbindAlert.seperatorViewColor = EH_linecor1;
    
    unbindAlert.contentView=[[UIView alloc]init];
    unbindAlert.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:unbindAlert.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [unbindAlert.contentView addConstraint:heightConstraint];
    
    //You can enable or disable blur, bouncing and motion effects
    unbindAlert.disableBouncingEffects = YES;
    unbindAlert.disableMotionEffects = YES;
    unbindAlert.disableBlurEffects = YES;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:unbindAlert animated:YES completion:nil];
}

/**
 *  上传头像
 */
- (void)uploadImage:(NSData *)imageData{
    [_loadingHud showWithStatus:@"正在上传中..." InView:self.view];
    [self setUpLoadService];
    [_uploadHeadImageService uploadImageWithData:imageData UserPhone:[KSLoginComponentItem sharedInstance].user_phone];
}

/**
 *  更新头像
 *
 *  @param url      大图地址
 *  @param smallUrl 小图地址
 */
- (void)modifyUserPicWithPicUrl:(NSString *)url SmallPicUrl:(NSString *)smallUrl{
    [self setModifyUserPicServiceWithPicUrl:(NSString *)url];
    [_modifyUserPicService modifyUserPicWithUserPhone:[KSLoginComponentItem sharedInstance].user_phone PicUrl:url SmallPicUrl:smallUrl];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"我的头像",@"我的昵称",@"我的账号",@"更改密码",@"消息设置", nil];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = titleArray[indexPath.section * 2 + indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.contentView addSubview:_headImageView];
        CGRect rect = [tableView convertRect:_headImageView.frame toView:nil];
        NSLog(@"rect: x= %f ,y= %f,w= %f, h= %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *nickName = [KSLoginComponentItem sharedInstance].nick_name;
        if (!nickName) {
            nickName = [KSLoginComponentItem sharedInstance].user_phone;
        }

        cell.detailTextLabel.text = nickName;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.detailTextLabel.text = [KSLoginComponentItem sharedInstance].user_phone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EHUserPicFetcherView *userPicFetcherView = [[EHUserPicFetcherView alloc]init];
            [userPicFetcherView showFromTarget:self];
            WEAKSELF
            userPicFetcherView.finishSelectedImageBlock = ^(NSData *selectedImageData){
                STRONGSELF
                EHLogInfo(@"finishSelectedImageBlock");
                //上传、更新、设置头像
                [strongSelf uploadImage:selectedImageData];
            };
        }
        else {
            UITableViewCell *__weak cell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSString *nickName = [KSLoginComponentItem sharedInstance].nick_name;
            if (!nickName) {
                nickName = [KSLoginComponentItem sharedInstance].user_phone;
            }
            
            EHModifyNickNameViewController *modifyNickNameVC = [[EHModifyNickNameViewController alloc]initWithNickName:nickName];
            modifyNickNameVC.modifyNickNameSuccess = ^(){
                NSString *nickNameStr = [KSLoginComponentItem sharedInstance].nick_name;
                cell.detailTextLabel.text = nickNameStr;
            };
            [self.navigationController pushViewController:modifyNickNameVC animated:YES];
        }
    }
    else {
        if (indexPath.row == 0) {
            TBOpenURLFromSourceAndParams(internalURL(kModifyPhoneSecurityPage), self, nil);
        }
        else if (indexPath.row == 1){
            TBOpenURLFromSourceAndParams(internalURL(kModifyPwdPage), self, nil);
        }
        else if (indexPath.row == 2){
            TBOpenURLFromSourceAndParams(internalURL(@"HSSettingViewController"), self, nil);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - Getters And Setters
- (void)initTableView{
    _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.rowHeight = kCellHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.view.backgroundColor = _tableView.backgroundColor;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    return;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame)-85, 10, 30, 30)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame) / 2.0;
        NSURL *imageUrl = [NSURL URLWithString:[KSLoginComponentItem sharedInstance].user_head_img];
        EHLogInfo(@"user_head_img = %@",[KSLoginComponentItem sharedInstance].user_head_img);
        [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"arrow"]];
        UITapGestureRecognizer *headImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewTap:)];
        [_headImageView addGestureRecognizer:headImageViewTap];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UIButton *)logOutButton{
    UIButton *logOutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - kCellHeight - 20, CGRectGetWidth(self.view.frame), kCellHeight)];
    logOutButton.backgroundColor = [UIColor whiteColor];
    [logOutButton setTitle:@"退出账号" forState:UIControlStateNormal];
    logOutButton.titleLabel.font = EH_font2;
    [logOutButton setTitleColor:EH_cor7 forState:UIControlStateNormal];
    [logOutButton addTarget:self action:@selector(logOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return logOutButton;
}

- (void)setUpLoadService{
    EHLoadingHud *__weak weakHud = _loadingHud;
    _uploadHeadImageService = [EHUploadUserPicService new];
    WEAKSELF
    _uploadHeadImageService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
            HSUserPicUrl *item = (HSUserPicUrl *)service.item;
            [strongSelf modifyUserPicWithPicUrl:item.original SmallPicUrl:item.compress];
    };
    _uploadHeadImageService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [weakHud showErrorWithStatus:@"上传失败！" Finish:^{}];
    };

}

- (void)setModifyUserPicServiceWithPicUrl:(NSString *)url{
    EHLoadingHud *__weak weakHud = _loadingHud;
    
    _modifyUserPicService = [EHModifyUserPicService new];
    
    UIImageView __weak *weakImageView = _headImageView;
    _modifyUserPicService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"设置完成！");
        [KSLoginComponentItem sharedInstance].user_head_img = url;
        [weakHud showSuccessWithStatus:@"更新头像成功" Finish:^{}];
        [weakImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:weakImageView.image options:SDWebImageProgressiveDownload | SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    };
    _modifyUserPicService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [weakHud showErrorWithStatus:@"设置失败！" Finish:^{}];
        
        //        NSDictionary* userInfo = error.userInfo;
        //        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

#pragma mark -
#pragma mark - EHLogOutAlertView

#define kBtnHeight 50
#define kSpace 10
#define kHudViewHeight (kBtnHeight * 3 + kSpace)
#define kHudViewWidth CGRectGetWidth(self.frame)

@implementation EHLogOutAlertView
{
    UIView *_alertView;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    }
    return self;
}

- (void)show{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    self.frame = window.bounds;
    [window addSubview:self];
    [self addSubview:[self alertView]];
    [self appearAnimated];
}

- (void)appearAnimated{
    _alertView.layer.transform = CATransform3DMakeTranslation(0, kHudViewHeight, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _alertView.layer.transform = CATransform3DIdentity;
    }];
}

- (void)disappearAnimatedAndLogout:(BOOL)logOut{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _alertView.layer.transform = CATransform3DMakeTranslation(0, kHudViewHeight, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (logOut) {
            !self.logOutBlock?:self.logOutBlock();
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self disappearAnimatedAndLogout:NO];
}

- (void)logOutButtonClick:(id)sender{
    [self disappearAnimatedAndLogout:YES];
}

- (void)cancleButtonClick:(id)sender{
    [self disappearAnimatedAndLogout:NO];
}

- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - kHudViewHeight, kHudViewWidth, kHudViewHeight)];
        _alertView.backgroundColor = [UIColor clearColor];
        [_alertView addSubview:[self contentLabel]];
        [_alertView addSubview:[self lineView]];
        [_alertView addSubview:[self logOutButton]];
        [_alertView addSubview:[self cancleButton]];
    }
    return _alertView;
}

- (UILabel *)contentLabel{
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kHudViewWidth, kBtnHeight)];
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.text = @"退出账号后，您将接受不到app的消息提醒";
    contentLabel.textColor = EH_cor5;
    contentLabel.font = EH_font6;
    contentLabel.textAlignment = NSTextAlignmentCenter;

    return contentLabel;
}

- (UIView *)lineView{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kBtnHeight - 0.5, kHudViewWidth, 0.5)];
    lineView.backgroundColor = EH_linecor1;
    
    return lineView;
}

- (UIButton *)logOutButton{
    UIButton *logOutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kBtnHeight, kHudViewWidth, kBtnHeight)];
    logOutButton.backgroundColor = [UIColor whiteColor];
    [logOutButton setTitle:@"退出账号" forState:UIControlStateNormal];
    [logOutButton setTitleColor:EH_cor7 forState:UIControlStateNormal];
    logOutButton.titleLabel.font = EH_font2;
    [logOutButton addTarget:self action:@selector(logOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return logOutButton;
}

- (UIButton *)cancleButton{
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kBtnHeight * 2 + kSpace, kHudViewWidth, kBtnHeight)];
    cancleButton.backgroundColor = [UIColor whiteColor];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:EH_cor4 forState:UIControlStateNormal];
    cancleButton.titleLabel.font = EH_font2;
    [cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cancleButton;
}

@end
