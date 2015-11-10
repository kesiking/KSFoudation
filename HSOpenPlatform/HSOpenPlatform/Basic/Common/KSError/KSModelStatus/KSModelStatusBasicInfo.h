//
//  TBModelStatusInfoB.h
//  Taobao2013
//
//  Created by 香象 on 28/2/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import "TBModelStatusInfo.h"

@interface KSModelStatusBasicInfo : TBModelStatusInfo

@property(nonatomic,strong)NSString * (^titleForEmptyBlock)(void);
@property(nonatomic,strong)NSString * (^subTitleForEmptyBlock)(void);
@property(nonatomic,strong)NSString * (^titleForErrorBlock)(NSError *error);
@property(nonatomic,strong)NSString * (^subTitleForErrorBlock)(NSError *error);
@property(nonatomic,strong)NSString * (^actionButtonTitleForEmptyBlock)(void);
@property(nonatomic,strong)NSString * (^actionButtonTitleForErrorBlock)(NSError *error);
@property(nonatomic,strong)UIImage *  (^imageForEmptyBlock)();
@property(nonatomic,strong)UIImage *  (^imageForErrorBlock)(NSError *error);

@end
