//
//  XMPPManager.h
//  ChatDemo
//
//  Created by yangxiaodong on 14/12/23.
//  Copyright (c) 2014年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "UserModel.h"
#import "FriendRequestModel.h"
#import "ImageModel.h"
#import "VoiceModel.h"
#import "MessageModel.h"
#import "RoomInfoModel.h"

#import "HistoryMessageRequestModel.h"
#import "RoomDetailModel.h"
#define creadGroupMessage @"建群消息"
#define inviteGroupMessage @"邀请消息"



typedef enum {
    XMPPManagerCodeSucess = 0,//发送成功
    XMPPManagerCodeDefault = 1,//文件不符合条件
    XMPPManagerDisConnected =2 ,//连接断开
    XMPPManagerSendnilTextMessage=3,//发送消息失败
    XMPPManagerSendnil=4,//空指针异常
    XMPPManagerSendnull=5,// 参数为空
    XMPPManagerFilerSendFail=6,//文件发送失败
    XMPPManagerFailJIdfail=7,//userName错误
    
    //以下四个用于获取历史消息失败
    XMPPManagerErrorCodeModelIsNil = 8, //传入的model为nil
    XMPPManagerErrorCodeGroupIllegal = 9, //查询群组历史消息时，传入的群组名称为空或不合法
    XMPPManagerErrorCodeToIsIllegal = 10, //查询单聊历史消息时，传入的对方jid为空或不合法
    XMPPManagerErrorCodeUsernameIllegal = 11, //获取本地自己的用户名失败
    XMPPManagerErrorCodeLimitIllegal = 12, //查询条数不大于0
    XMPPManagerErrorCodeNoNetwork = 13, //没有网络
    XMPPManagerErrorCodeCannotLinkToServer = 14, //连接服务器失败
    XMPPManagerFailUnKnow //未知错误
}XMPPManagerErrorCode;

typedef enum
{
    XMPPManagerRoomCodeSucess = 0,//发送成功
    XMPPManagerRoomCodeDefault = 1,//文件不符合条件
    XMPPManagerRoomDisConnected =2 ,//连接断开
    XMPPManagerRoomSendnilTextMessage=3,//发送消息失败
    XMPPManagerRoomnil=4,//空指针异常
    XMPPManagerRoomnull=5,//参数为空
    XMPPManagerRoomFilerSendFail=6,//文件发送失败
    XMPPManagerRoomFailJIdfail=7//RoomJId错误
}XMPPManagerRoomErrorCode;


typedef enum {
    XMPPManagerGroupNameNil = 0,//群名称为nil;
    XMPPManagerGroupnameNUll =1,//群组名为空；
    XMPPManagerGroupNameillegal = 2,//群名字不合法；
    XMPPManagerGroupFail =4,//创建失败
}CreatRoomErrorCode;


#pragma mark 登录
typedef void (^loginsucessful)();//登录成功
typedef void (^loginfail)(NSString *error);//登录失败


#pragma mark 注册
typedef void (^registersucessful)();//注册成功
typedef void (^registerFail)(NSString * error);//注册信息不合法
typedef void (^registerphoneCodeSuccessful)();//验证码正确
typedef void (^registerphoneCodefaile)(NSString *error);//验证码错误

#pragma mark- 订阅推送
typedef void (^subscribeSucessful)();//订阅推送成功（发送Token成功）
typedef void (^subscribeFail)(NSString * error);//订阅推送失败（Token格式错误）

#pragma mark 重复登录
typedef   void (^repetitionLogin)(NSString *error);
typedef void (^servercontectSucessful)(NSString *successFul); //连接成功
typedef void (^servercontectfail)(NSString *fail);//连接失败
typedef void (^platformDeleteUser)(NSString * deleteUser);//平台删除

#pragma mark 好友请求block
typedef void(^ReturnPresenceFromUser)(FriendRequestModel * model);///<收到好友请求的回调

typedef void(^AddFriendSubscribeSucess)(); ////<发送好友请求回调
typedef void (^AddFrendSubscribrFail)(NSString *error);//发送好友回调失败

typedef void(^DeleteFriendSucess)();//删除好友回调成功
typedef void(^DeleteFriendfail)(NSString *error);//删除好友回调失败

typedef void(^AddFriendSucess)();//接受好友回调
typedef void(^AddFriendFail)(NSString *error);//接受好友回调失败


typedef void(^RejectFriendSucess)();//拒绝好友回调成功
typedef void(^RejectFriendfail)(NSString *error);//拒绝好友回调失败

#pragma mark 接受消息
typedef void(^ReceiveMessageSuccess)(MessageModel * model);//<收到好友发送的消息.

#pragma mark 自己发送消息
typedef void (^SendSelfMessageSuccess)(MessageModel *model);//自己发送的消息


#pragma mark 获取好友列表结束block
typedef void(^RosterDidEndPopulating)(NSArray * array);//<获取好友列表结束回调
#pragma mark 搜索联系人block
typedef void(^DidBeginSearchUser) (void);//<开始搜索好友回调
typedef void(^DidFinshSearchUser) (NSArray * array);//<搜索好友结束回调
typedef void(^DidFailSearchUser)  (NSString * error);//<搜索好友失败回调

#pragma mark 图片上传block
typedef void (^UpdataImageBegain)(void);//图片开始上传回调
#pragma mark 声音上传block
typedef void (^UpdataVoiceBegin)(void);//<声音开始上传回调

#pragma mark 获取群组列表block
typedef void (^RequestRoomBegin)(void);//<开始获取群组回调
typedef void (^RequestRoomsSucess)(NSArray * array);//<获取群组结束回调
typedef void (^RequestRoomsError)(NSString * error);//<获取群组失败回调
typedef void (^RequestRoomsDidSucess)(NSArray * arr);


#pragma mark 获取群详情block
typedef void (^RequestRoomDetaileBegin) (void);//开始获取群详情回调
typedef void (^RequestRoomDetaileSucess) (RoomInfoModel * model);//获取群详情结束回调
typedef void (^RequestRoomDetaileError) (NSString * error);//获取群详情失败回调


#pragma mark 获取群主详情block
typedef void (^RequestHaremMasterBegin) (void);//开始获取群主详情回调
typedef void (^RequestHaremMasterSucess) (UserModel * model);//获取群主详情结束回调
typedef void (^RequestHaremMasterError) (NSString * error);//获取群主详情失败回调


#pragma mark 获取群成员详情block
typedef void (^RequestMasterBegin) (void);//开始获取群成员详情回调
typedef void (^RequestMasterSucess) (NSArray * array);//获取群成员详情结束回调
typedef void (^RequestMasterError) (NSString * error);//获取群成员详情失败回调

#pragma mark 邀请
typedef void (^requestinvitenewGroup)(RoomInfoModel *roominfomodel);

#pragma mark 创建群结束block
typedef void(^CreatRoomSuccess)(BOOL ret,XMPPRoom * model);//<创建群结束回调
typedef void(^CreatRoomError)(CreatRoomErrorCode code);//创建群失败




#pragma mark 群管理消息block
typedef void(^ReceviedGroupManagerMessage)(MessageModel * sender);///<群管理消息回调


#pragma mark 退群block
typedef void(^LeaveRoom)(BOOL ret);///<退群回调


#pragma mark 邀请好友
typedef void(^inviterfriends) (BOOL ret);


#pragma mark  消息发送状态
typedef void (^messagesendsucessful)(BOOL ret,XMPPManagerErrorCode code);//消息回调
typedef void (^chatmessagesendsucessful)(BOOL ret,XMPPManagerRoomErrorCode code);//群聊消息回调


typedef void (^returnUserInfo)(UserModel *userModel);//返回当前登陆用户的信息
typedef void (^returnOtherUserInfo)(UserModel *otherUserModel);//返回其他用户的信息
typedef void (^createGroupmodel)(RoomInfoModel *model);//创建回调
typedef void (^inviteGroupmodel)(RoomInfoModel *model);//回调群邀请
typedef void (^exitGroupmodel)(RoomInfoModel *model);//回调退出群
typedef void (^modityGroupName)(RoomInfoModel *model);//修改群组名字监听

typedef void (^returnRosterArray)(NSMutableArray *rosterArray);//回调好友数组


typedef void (^returnGroupListModel)(RoomInfoModel *roominfomolde);//回调群成员

typedef void (^ModifyGroupNameSuccessful)();//回调是否修改成功
typedef   void(^ModifyGroupNameFail)(NSString *error);//修改失败



@interface XMPPManager : NSObject< XMPPRosterDelegate,XMPPStreamDelegate,XMPPRoomStorage>

+ (XMPPManager *)defaultManager;

//创建流  也就是通信管道
@property (nonatomic, strong)XMPPStream * xmppStream;
//创建花名册
@property (nonatomic, strong)XMPPRoster * xmppRoster;
@property (nonatomic, strong)XMPPJID * subscriptJid;  //好友身份标识
@property (nonatomic, strong)XMPPMessageArchiving * messageArchiving;
@property (nonatomic, strong)NSManagedObjectContext * messageArchivingManagedContext;
@property(nonatomic,strong)NSMutableDictionary *roomDict;///<已经初始化的xmmppRoom对象
@property(nonatomic, strong)NSDictionary *createRoomJIDs;
@property(nonatomic, strong)NSArray *addMemberJIDs;
//存放好友花名册
@property(nonatomic,strong)XMPPJID *roomJID;///<房间id
@property(nonatomic, assign) XMPPRoomCoreDataStorage* storage;

@property (nonatomic,strong)NSMutableArray *rostersArray;
@property (nonatomic,strong)NSMutableArray * roomArray;
@property (nonatomic,copy)NSString *firstLogin;
@property (nonatomic,copy)NSArray  *grouplistArray;
@property (nonatomic,strong)NSData *deviceToken;//推送需要传的deviceToken

@property (nonatomic,copy)NSString *appKey;

#pragma mark -登录成功
@property (nonatomic,copy)loginsucessful loginsuccess;
@property (nonatomic,copy)loginfail loginfail;

#pragma mark -注册成功
@property (nonatomic,copy)registersucessful registersucess;
@property (nonatomic,copy)registerFail registerfail;
@property (nonatomic,copy)registerphoneCodeSuccessful registercode;
@property (nonatomic,copy)registerphoneCodefaile registerphonefail;

#pragma mark- 订阅推送
@property (nonatomic,copy)subscribeSucessful subscribeSucessfulBlock;
@property (nonatomic,copy)subscribeFail subscribeFailBlock;

#pragma mark - 重复登录（监听）
@property(nonatomic,copy)repetitionLogin repetlogin;
@property (nonatomic,copy)servercontectSucessful servercontect;
@property (nonatomic,copy)servercontectfail servercontectfail;
#pragma mark -平台删除账号
@property (nonatomic,copy)platformDeleteUser platformDeleteUser;
@property (nonatomic,copy)modityGroupName modityGroupName;



@property (nonatomic,copy)returnRosterArray returnRosterArray;//返回好友列表
@property (nonatomic, copy)ReturnPresenceFromUser  returnPresenceFromUser;//<收到好友请求回调
@property (nonatomic, copy)AddFriendSubscribeSucess addFriendSubscribeSucess;//<发送好友请求回调
@property (nonatomic,copy)AddFrendSubscribrFail addFrendsubscriblrfail;//收到好友请求失败
@property (nonatomic, copy)DeleteFriendSucess deleteSucess;//<删除好友回调
@property (nonatomic,copy)DeleteFriendfail deletefail;//删除好友失败
@property (nonatomic, copy)AddFriendSucess addSucess;//<接受好友回调
@property (nonatomic,copy)AddFriendFail addfriendfail;//接受好友回调失败
@property (nonatomic, copy)RejectFriendSucess rejectFriendSucess;//拒绝好友申请成功
@property (nonatomic,copy)RejectFriendfail rejectfriendfail;//拒绝好友申请失败

#pragma mark 单聊与接收block属性
@property (nonatomic, copy)ReceiveMessageSuccess receivemessagesucess;//<收到好友发送的消息以及发送消息回调
@property (nonatomic,copy)SendSelfMessageSuccess sendselfmesssuccess;//自己发送的消息


#pragma mark获取好友列表结束block属性

@property (nonatomic, copy)RosterDidEndPopulating  rosterDidEndPopulating;//<获取好友列表结束回调


#pragma mark 搜索联系人block属性

@property (nonatomic, copy)DidBeginSearchUser didBeginSearch;//<开始搜索好友回调
@property (nonatomic, copy)DidFinshSearchUser didFinshSearch;//<搜索好友结束
@property (nonatomic, copy)DidFailSearchUser didFailSearch;//<搜索好友失败

#pragma mark 图片上传block属性
@property (nonatomic,copy)UpdataImageBegain updataImageBegin;
#pragma mark 声音上传block属性
@property (nonatomic, copy) UpdataVoiceBegin updataVoiceBegin;

#pragma mark 获取群组block属性

@property(nonatomic,copy) RequestRoomBegin requestRoomBegin;//<开始获取群列表回调
@property(nonatomic,copy) RequestRoomsSucess requestRoomeSucess;//<获取群列表结束回调
@property(nonatomic,copy) RequestRoomsError requestRoomeError;//<获取群列表失败回调
@property(nonatomic,copy) RequestRoomsDidSucess requestDidSucess;//<获取群列表结束回调

#pragma mark 获取群详情block属性
@property(nonatomic,copy)RequestRoomDetaileBegin requestRooomDetaileBegin;//<开始获取群详情回调
@property(nonatomic,copy)RequestRoomDetaileSucess requestRoomDetaileSucess;///<获取群详情结束回调
@property(nonatomic,copy)RequestRoomDetaileError requestRooomDetaileError;

#pragma mark 获取群主详情block属性
@property(nonatomic,copy)RequestHaremMasterBegin requestHaremMasterBegin;//<开始获取群主详情回调
@property(nonatomic,copy)RequestHaremMasterSucess requestHaremMasterSucess;///<获取群主详情结束回调
@property(nonatomic,copy)RequestHaremMasterError requestHaremMasterError;

#pragma mark 获取群成员详情block属性
@property(nonatomic,copy)RequestMasterBegin requestMasterBegin;//<开始获取群成员详情回调
@property(nonatomic,copy)RequestMasterSucess requestMasterSucess;///<获取群成员详情结束回调
@property(nonatomic,copy)RequestMasterError requestMasterError;
@property (nonatomic,copy)requestinvitenewGroup requestinvitenewgroup;


#pragma mark 创建完群block属性
@property(nonatomic,copy)CreatRoomError creatRoomError;
@property(nonatomic,copy)CreatRoomSuccess creatRoomSuccess;///<是否创建成功回调



#pragma mark 退群block属性
@property(nonatomic,copy)LeaveRoom haveleaveRoom;//退群回调
@property (nonatomic,copy)returnGroupListModel returngrouplistmodel;


#pragma mark - 注册&登陆&退出&token验证
@property (nonatomic,copy)inviterfriends inviterfiend;
@property (nonatomic,copy)createGroupmodel createGroupmodel;
@property (nonatomic,copy)inviteGroupmodel inviteGroupmodel;
@property (nonatomic,copy)exitGroupmodel exitGroupmodel;
@property (nonatomic,copy)modityGroupName moditygroupName;
@property (nonatomic,copy)messagesendsucessful messsendstatic;
@property (nonatomic,copy)chatmessagesendsucessful chatmesssagesendstaic;
@property (nonatomic,copy)returnUserInfo returnuserInfo;
@property (nonatomic,copy)ModifyGroupNameSuccessful modifygroupnamesuccessful;
@property (nonatomic,copy)ModifyGroupNameFail modifygroupnamefail;






/**
 *  填写appkey
 */
-(void)onCreateAppkey:(NSString *)appkey;

/**
 *  登陆
 *  @param userName
 *  @param password
 */

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
      loginblockSucessful:(loginsucessful )loginblock
                loginFail:(loginfail )loginfail;

/**
 *  注册需要手机号
 *  @param userName
 *  @param userPassword
 *  @param nikeName
 *  @param phoneNumber
 */

- (void)registerWithUserName:(NSString *)userName userPassword:(NSString *)userPassword affirmPassword:(NSString *)affirmPassword nikeName:(NSString *)nikeName phoneNumber:(NSString *)phoneNumber registerSuccessful:(registersucessful )registerSuccessFul
                registerfail:(registerFail )registerfail;


/**
 *  注册不需要手机号
 *  @param userName
 *  @param userPassword
 *  @param nikeName
 *  @param phoneNumber
 */

- (void)registerWithNoPhoneUserName:(NSString *)userName userPassword:(NSString *)userPassword affirmPassword:(NSString *)affirmPassword nikeName:(NSString *)nikeName
                 registerSuccessful:(registersucessful )registerSuccessFul
                       registerfail:(registerFail )registerfail;


/**
 *  再次发送验证码
 */

-(void)aginRegisterinfo;

/**
 *  手机发送验证码
 */
-(void)sendVerificationcode:(NSString *)code
               registercode:(registerphoneCodeSuccessful)registercode
               registerfail:(registerphoneCodefaile )registerfail;


/**
 *退出登录
 */
-(void)goOffLine;

/**
 *  释放sdk
 */
-(void)releaseXmppManager;

#pragma mark - push推送
/**
 *	@brief	 订阅推送
 *
 *	@param   crtType      推送证书类型：develop(开发调试用) or product（发布用）
 *
 */
- (void)subscribePushNotification:(NSString*)crtType subscribeSuccessful:(subscribeSucessful)subscribeSucessful subscribeFail:(subscribeFail)subscribeFail;

/**
 *  取消推送
 */
- (void)cancelPushNotification;

/**
 *  设置未读消息数
 *  发送给服务器，用于同步服务器推送BadgeNumber的值
 */
- (void)setUnReadMessageCount:(NSInteger)count;

#pragma -mark
/**
 *退出登录与服务连接的状态及被平台删除
 */

-(void)repeatLoginblock:(repetitionLogin )repetionloginblock
          contectSuccessful:(servercontectSucessful )serverSuccessful
                contectFail:(servercontectfail )contectFail
     platformDeleteUser:(platformDeleteUser) deleteUser;


#pragma mark - 好友

/**
 *  好友监听
 * 收到好友邀请
 * 对方同意你为好友
 * 对⽅方好友拒绝
 * 被好友删除
 */
//为保持兼容保留此接口，与下面其实是一个
-(void)returnPresenceFromUserListern:(ReturnPresenceFromUser )returnPresencelisten;
-(void)returnPresenceFromUser:(ReturnPresenceFromUser )returnPresencelisten;
/**
 *  发送好友的请求
 *
 *  @param userName
 */

- (void)XMPPAddFriendSubscribe:(NSString *)userName addSucess:(AddFriendSubscribeSucess) sucess
                       addFail:(AddFrendSubscribrFail )fail;

/**
 *  删除好友
 *  @param userName
 */

- (void)removeFriend:(NSString *)userName deleteSucess:(DeleteFriendSucess)sucess
          deletefail:(DeleteFriendfail )delefail;

/**
 *  接受好友
 *  @param subjectUserName
 */

-(void)acceptPresenceSubscriptionRequestFrom:(NSString *)subjectUserName addSucess:(AddFriendSucess) sucess addFail:(AddFrendSubscribrFail )fail;

/**
 *  拒绝好友
 *  @param subjectUserName
 */

-(void)rejectPresenceSubscriptionRequestFrom:(NSString *)subjectUserName rejectSucess:(RejectFriendSucess) sucess rejectfail:(RejectFriendfail )rejectfail;



/**
 *  获取好友列表结束回调
 */

-(void)rosterDidEndPopulating:(RosterDidEndPopulating)loadAllContacts;



/**
 *  搜索好友
 *  @param userName
 *
 */

-(void)searchUser:(NSString *)userName searchBegin:(DidBeginSearchUser)begin searchFinsh:(DidFinshSearchUser)finsh seachError:(DidFailSearchUser)error;




#pragma mark - 单聊

/**
 *  单聊发送文字消息
 *
 *  @param text
 *  @param userName
 */

-(void)sendmessages:(NSString *)text to:(NSString *)userName
       messageblock:(messagesendsucessful)messagestatic;
/**
 *  单聊发送图片消息
 *
 *  @param path
 *  @param userName
 */
-(void)sendImage:(NSString *) path
updataImagebegin:(UpdataImageBegain )updataBgin
              to:(NSString *)userName
    messageblock:(messagesendsucessful)messagestatic;

/**
 *  单聊发送声音消息
 *  @param model
 *  @param userName
 */

-(void)sendVoice:(NSString *) path voiceLength:(NSInteger)length
updataVoiceBegin:(UpdataVoiceBegin )updataVoice
              to:(NSString *)userName
    messageblock:(messagesendsucessful)messagestatic;


/**
 *  收到他人发送的消息model
 *
 */

-(void)receiveMessageBlock:(ReceiveMessageSuccess) ReceiveMessageSuccess;

/**
 *  收到自己发送的消息model
 *
 */

-(void)sendselfmessageblock:(SendSelfMessageSuccess )sendselfmessageSuccesssful;

#pragma mark - 聊天室

/**
 *  创建聊天室
 *
 *  @param roomName
 *  @param userNames
 */

-(void)creatRoomWithName:(NSString *)roomName userNames:(NSDictionary *)userNames compltion:(CreatRoomSuccess)creatSuccess createError:(CreatRoomError)createrRoomError;




/**
 *  邀请成员
 *
 */

-(void)inviteOther:(NSString *)roomJid personDic:(NSDictionary *)persondic compltion:(inviterfriends )interfriend;

/**
 *
 *修改房间名字
 */

-(void)ModifytheGroupName:(NSString *)GroupName
                  roomJID:(NSString *)roomJId
   modifyGroupnamesuccess:(ModifyGroupNameSuccessful )ModifyGroupnamesuccess
      modifyGroupnamefail:(ModifyGroupNameFail )modifygroupnameFail;


/**
 *  退出房间
 *
 *  @param room
 *  @param leaveRoom
 */

-(void)outRoom:(NSString  *)roomJid compltion:(LeaveRoom)leaveRoom;


/**
 *  新群收到监听消息
 *  邀请收好友的监听消息
 *  退出群的监听消息
 *  修改群名称监听消息
 */
-(void)createGroupmodel:(createGroupmodel )creategroupmodel
       inviteGroupmodel:(inviteGroupmodel )inviteGroupmodel
          exitgroupmoel:(exitGroupmodel )exitgroupmodel
        moditygroupName:(modityGroupName )moditygroupName;


/**
 *  群文字表情消息
 *
 *  @param text
 *  @param roomId
 */
-(void)sendGroupMessage:(NSString *)text roomId:(NSString *)roomId
           messageblock:(chatmessagesendsucessful)messagestatic;

/**
 *  群图片消息
 *
 *  @param str
 *  @param roomId
 */
-(void) sendImage:(NSString *) path
          updataImagebegin:(UpdataImageBegain )updataBgin
         roomId:(NSString *)roomId
                messageblock:(chatmessagesendsucessful)messagestatic;
/**
 *  群语音消息
 *
 *  @param str
 *  @param roomId
 */
-(void) sendVoice:(NSString *) path voiceLength:(NSInteger)length
          updataVoiceBegin:(UpdataVoiceBegin )updataVoicebegin
                    roomId:(NSString *)roomId
               messageblock:(chatmessagesendsucessful)messagestatic;



/**
 *  登录后获取群组列表结束回调
 *
 */

-(void)RequestRoomListEnd:(RequestRoomsDidSucess)sucess;

/**
 *
 *返回当前登陆用户的信息
 */

-(void)returnUserInfoModel:(returnUserInfo )returnInfoModel;

/**
 *
 *被一个邀请的到一个新群返回该群的群成员
 */

-(void)requestinvitenewGroupbolck:(requestinvitenewGroup )requestinviternewgroup;


/**
 *
 *登录后获取房间成员
 */

-(void)returnRoominfoModel:(returnGroupListModel )returnRoominfoModel;




/**
 *  获取群组列表
 *
 */

-(void)RequestRoomListBegin:(RequestRoomBegin)begin requestSucess:(RequestRoomsSucess)sucess requestError:(RequestRoomsError)err;


/**
 *  获取群详情
 *
 *  @param roomJid
 *
 */

- (void)getRoomNameWithJid:(NSString *)roomjid requestBegin:(RequestRoomDetaileBegin) begin  requestSucess:(RequestRoomDetaileSucess)sucess requestError:(RequestRoomDetaileError) error;

/**
 *  获取群主
 *
 */

-(void)requestHaremMaster:(NSString *)roomjid requestBegin:(RequestHaremMasterBegin) begin  requestSucess:(RequestHaremMasterSucess)sucess requestError:(RequestHaremMasterError) error;

/**
 *  获取群成员
 *
 */

-(void)requestMember:(NSString *)roomjid requestBegin:(RequestMasterBegin) begin  requestSucess:(RequestMasterSucess)sucess requestError:(RequestMasterError) error;



#pragma mark -
#pragma mark - 历史消息记录获取

/**
 请求单聊历史消息
 如果返回的messagesArray的count为0，说明没有更多历史信息了，或输入的条件查不到
 */
- (void)requestHistoryMessage:(HistoryMessageRequestModel*)requestModel finish:(void (^)(NSArray *messagesArray))aSuccess fail:(void (^)(XMPPManagerErrorCode erroCode))aFail;

/**
 请求群组历史消息
 如果返回的messagesArray的count为0，说明没有更多历史信息了，或输入的条件查不到
 */
- (void)requestGroupHistoryMessage:(HistoryMessageRequestModel*)requestModel finish:(void (^)(NSArray *messagesArray))aSuccess fail:(void (^)(XMPPManagerErrorCode erroCode))aFail;






@end
