//
//  HSBussinessDetailVerticalContainer.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "HSApplicationModel.h"

@interface HSBussinessDetailVerticalContainer : KSView

@property (nonatomic, strong) WeAppComponentBaseItem         *bussinessDetailModel;

@property (nonatomic, strong) HSApplicationModel             *appModel;

@property (nonatomic, strong) NSString                       *appId;

- (void)reloadDataAndContaier;

@end
