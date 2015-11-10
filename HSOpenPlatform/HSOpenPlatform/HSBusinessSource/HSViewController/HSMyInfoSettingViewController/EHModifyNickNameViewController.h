//
//  EHModifyNickNameViewController.h
//  eHome
//
//  Created by xtq on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"

typedef void (^ModifyNickNameSuccess)(void);

@interface EHModifyNickNameViewController : KSViewController

@property(nonatomic,strong)ModifyNickNameSuccess modifyNickNameSuccess;

- (instancetype)initWithNickName:(NSString *)nickName;

@end
