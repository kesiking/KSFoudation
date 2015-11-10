//
//  TBErrorInfo.h
//  Taobao2013
//
//  Created by 晨燕 on 12-12-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkLoadingTitle                    @"正在加载..."
#define kNetworkErrorHint                       @"没有网络哦,请检查一下系统设置吧"

#define kNetworkErrorTitle                      @"亲，您的手机网络不太顺畅喔~"
#define kLoginErrorTitle                        @"状态异常"
#define kErrorAndRefreshTitle                   @"加载失败点击刷新"
#define kNoAddressTitle                         @"还没有收货地址"
#define kAddNewAddressTitle                     @"新建收货地址"
#define kBackTitle                              @"返回"

#define kEmptyTitle                             @"数据为空"
#define kEmptySubtitle                          @"暂时没有相关数据"

#define kNetworkErrorSubTitle                   @""
#define kNetworkErrorDefaultSubTitle            @"请检查您的手机是否联网"
#define kLoginStatusSubTitleError               @"您的登录状态失效，正在重新登录..."
#define kNeedReloginSubTitleError               @"您的登录状态失效，请重新登录"

#define kNetworkErrorButtonTitle                @"重新加载"
#define kReLoginButtonTitle                     @"重新登录"
#define kRefreshButtonTitle                     @"重新刷新"

#define kServiceErrorTitle                      @"网络异常"
#define kServiceErrorSubTitle                   @"不能正常访问淘宝服务"


//////////////////////////////////////////
//服务端的errorcode集合
#define ERRCODE_QUERY_DETAIL_FAIL  @"ERRCODE_QUERY_DETAIL_FAIL"
#define ERRCODE_NO_ADDRESS         @"NO_ADDRESS"

@interface TBModelStatusInfo : NSObject


typedef NSString*(^ TitleBock)(id );//TBErrorResponse


@property(nonatomic,strong)TitleBock actionTitleBlock;
@property(nonatomic,strong)TitleBock titleBlock;
@property(nonatomic,strong)TitleBock subtitleBlock;


// need to reload to set real value
- (NSString *)titleForEmpty;
- (NSString *)subTitleForEmpty;
- (UIImage *)imageForEmpty;
- (NSString*)actionButtonTitleForEmpty;
- (NSString *)titleForError:(NSError *)error;
- (NSString *)subTitleForError:(NSError *)error;
- (UIImage *)imageForError:(NSError *)error;

- (NSString*)actionButtonTitleForError:(NSError*)error;

@end
