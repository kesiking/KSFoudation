//
//  EHHomeNavBarRightView.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSMessageNavBarRightView.h"
#import "HSUpdateMessageNumberService.h"

#define BTN_IMAGE_WIDTHT            (30.0)
#define BTN_IMAGE_HEIGHT            (28.0)

@interface HSMessageNavBarRightView()

@property (nonatomic, strong) HSUpdateMessageNumberService *messageNumberService;

@property (nonatomic, assign) NSUInteger                    messageNumber;

@end

@implementation HSMessageNavBarRightView

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    });
    return sharedCenter;
}
-(void)setupView{
    [super setupView];
    [self initCommonInfo];
    [self initTitleButton];
    [self initNotification];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCommonInfo{
    self.messageNumber = 0;
}

-(void)initTitleButton{
    _btn = [[UIButton alloc] initWithFrame:self.bounds];
    [_btn setImage:[UIImage imageNamed:@"nav_Message_normal"] forState:UIControlStateNormal];
    [_btn setImageEdgeInsets:UIEdgeInsetsMake((_btn.height - BTN_IMAGE_HEIGHT)/2, (_btn.width - BTN_IMAGE_WIDTHT), (_btn.height - BTN_IMAGE_HEIGHT)/2, 0)];
    [_btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(remoteMessageAction:)
                                                 name:EHRemoteMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearRemoteMessageAction:)
                                                 name:EHClearRemoteMessageAttentionNotification
                                               object:nil];
}

-(void)buttonClicked:(id)sender{
    // 小红点展示时才发请求通知清除，否则不发送，减少请求次数
    if (self.messageNumber != 0) {
        [self.messageNumberService updateMessageNumberWithUserPhone:[KSAuthenticationCenter userPhone]];
    }
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock(self);
    }
}

-(void)setupPointImageStatusWithNumber:(NSNumber*)number{
    NSUInteger numberInt = [number integerValue];
    self.messageNumber = numberInt;
    if (numberInt > 0) {
        [_btn setImage:[UIImage imageNamed:@"nav_Message_prompt"] forState:UIControlStateNormal];
    }else{
        [_btn setImage:[UIImage imageNamed:@"nav_Message_normal"] forState:UIControlStateNormal];
    }
}

-(HSUpdateMessageNumberService *)messageNumberService{
    if (_messageNumberService == nil) {
        _messageNumberService = [HSUpdateMessageNumberService new];
        WEAKSELF
        _messageNumberService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            EHLogInfo(@"----> update message number service success");
            [strongSelf setupPointImageStatusWithNumber:@0];
            [[NSNotificationCenter defaultCenter] postNotificationName:EHClearRemoteMessageAttentionNotification object:nil userInfo:nil];
        };
    }
    return _messageNumberService;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)remoteMessageAction:(NSNotification*)notification{
    [self setupPointImageStatusWithNumber:[NSNumber numberWithUnsignedInteger:self.messageNumber + 1]];
}

-(void)clearRemoteMessageAction:(NSNotification*)notification{
    [self setupPointImageStatusWithNumber:@(0)];
}

@end
