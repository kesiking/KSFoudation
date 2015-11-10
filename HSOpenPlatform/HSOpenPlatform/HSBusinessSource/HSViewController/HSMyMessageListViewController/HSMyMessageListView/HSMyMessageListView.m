//
//  HSMyMessageListView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMyMessageListView.h"
#import "HSMessageListDeleteBottom.h"
#import "HSMyMessageInfoListService.h"
#import "HSDeleteMyMessageInfoService.h"
#import "HSMessageCellModelInfoItem.h"
#import "HSMyMessageInfoCell.h"

@interface HSMyMessageListView()

@property (nonatomic,strong) HSMessageListDeleteBottom*     deleteView;

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@property (nonatomic,strong) HSMyMessageInfoListService*    messageInfoListService;

@property (nonatomic,strong) HSDeleteMyMessageInfoService*  deleteMessageInfoService;

@property (nonatomic,assign) BOOL                           isEditing;

@end

@implementation HSMyMessageListView

-(void)setupView{
    [super setupView];
    [self addSubview:self.tableViewCtl.scrollView];
    [self addSubview:self.deleteView];
    [self refreshDataRequest];
}

-(void)refreshDataRequest{
    [self refreshDataRequestWithUserPhone:[KSAuthenticationCenter userPhone]];
}

-(void)refreshDataRequestWithUserPhone:(NSString*)userPhone{
    [self.messageInfoListService loadMyMessageInfoListWithUserPhone:userPhone];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _dataSourceRead = nil;
    _dataSourceWrite = nil;
}

-(void)setIsTableViewEdit:(BOOL)isTableViewEdit{
    // 如果当前正在操作不能执行reloadData
    if (self.isEditing) {
        return;
    }
    _isTableViewEdit = isTableViewEdit;
    
    KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.tableViewCtl.configObject);
    configObject.isEditModel = isTableViewEdit;
    configObject.serviceCanLoadData = !isTableViewEdit;
    [self.tableViewCtl reloadData];
    
    [self deleteBottomDoAnimation:isTableViewEdit];
}

-(void)deleteBottomDoAnimation:(BOOL)isTableViewEdit{
    CGRect rect = self.deleteView.frame;
    if (isTableViewEdit) {
        rect.origin.y = self.bottom - rect.size.height;
    }else{
        rect.origin.y = self.bottom;
    }
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [self.deleteView setFrame:rect];
    } completion:nil];
    _isTableViewEdit = isTableViewEdit;
}

-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_tableViewCtl setErrorViewTitle:@"您暂无消息"];
        [_tableViewCtl setHasNoDataFootViewTitle:@"已无信息可同步"];
        [_tableViewCtl setNextFootViewTitle:@""];
        [_tableViewCtl registerClass:[HSMyMessageInfoCell class]];
        [_tableViewCtl setService:self.messageInfoListService];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
        _tableViewCtl.scrollView.backgroundColor = EHBgcor1;
    }
    return _tableViewCtl;
}

#pragma mark - deleteView 操作
-(HSMessageListDeleteBottom *)deleteView{
    if (_deleteView == nil) {
        CGRect rect = self.bounds;
        rect.size.height = 44;
        rect.origin.y = self.bottom;
        _deleteView = [[HSMessageListDeleteBottom alloc] initWithFrame:rect];
        WEAKSELF
        _deleteView.deleteViewDidClickedBlock = ^(){
            STRONGSELF
            [strongSelf deleteSelectedCollectionCell];
        };
    }
    return _deleteView;
}

#pragma mark - deleteSelectCollectionCell 操作
- (void)deleteSelectedCollectionCell{
    /*
     // 删除后不能继续删除的逻辑
     // 注释后为可连续删除
     KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.collectionViewCtl.configObject);
     configObject.isEditModel = NO;
     */
    self.tableViewCtl.scrollView.userInteractionEnabled = NO;
    self.isEditing = YES;
    WEAKSELF
    [self.tableViewCtl deleteCollectionCellProccessBlock:^(NSArray *collectionDeleteItems,KSDataSource* dataSource) {
        STRONGSELF
        // 发送请求删除服务端数据
        NSMutableArray* messageIds = [NSMutableArray array];
        [collectionDeleteItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSIndexPath class]]) {
                NSIndexPath* indexPath = obj;
                if ([dataSource count] <= [indexPath row]) {
                    *stop = YES;
                    return;
                }
                HSMyMessageModel* messageModel = (HSMyMessageModel*)[dataSource getComponentItemWithIndex:[indexPath row]];
                if (messageModel
                    && [messageModel isKindOfClass:[HSMyMessageModel class]]
                    && messageModel.msgId) {
                    [messageIds addObject:messageModel.msgId];
                }
            }
        }];
        [strongSelf.deleteMessageInfoService deleteMyMessagesInfoWithUserPhone:[KSAuthenticationCenter userPhone] messageIds:messageIds];
    } completeBolck:^{
        [self.tableViewCtl refreshData];
        self.tableViewCtl.scrollView.userInteractionEnabled = YES;
        self.isEditing = NO;
    }];
}

#pragma mark - messageInfoListService 操作
-(HSMyMessageInfoListService *)messageInfoListService{
    if (_messageInfoListService == nil) {
        _messageInfoListService = [HSMyMessageInfoListService new];
        WEAKSELF
        _messageInfoListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _messageInfoListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
        _messageInfoListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
    }
    return _messageInfoListService;
}

-(HSDeleteMyMessageInfoService *)deleteMessageInfoService{
    if (_deleteMessageInfoService == nil) {
        _deleteMessageInfoService = [HSDeleteMyMessageInfoService new];
        WEAKSELF
        _deleteMessageInfoService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _deleteMessageInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [WeAppToast toast:@"删除成功"];
            [strongSelf hideLoadingView];
        };
        _deleteMessageInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [WeAppToast toast:@"删除失败，请稍后再试"];
            [strongSelf hideLoadingView];
        };
    }
    return _deleteMessageInfoService;
}

#pragma mark - dataSourceRead and dataSourceWrite   操作
-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
        _dataSourceRead.modelInfoItemClass = [HSMessageCellModelInfoItem class];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
        _dataSourceWrite.modelInfoItemClass = [HSMessageCellModelInfoItem class];
    }
    return _dataSourceWrite;
}

@end
