//
//  HSBusinessInfoBasicView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "HSDeviceModel.h"
#import "HSDeviceInfoModel.h"

#define BussinessDetailBorderLeft   (15.0)
#define BussinessDetailBorderRight  (BussinessDetailBorderLeft)
#define BussinessDetailWidth        (self.width - BussinessDetailBorderLeft - BussinessDetailBorderRight)

#define BussinessDetailBorderTop    (0.0)
#define BussinessDetailBorderBottom (0.0)

@class HSBusinessInfoBasicView;

typedef void(^businessViewDidSelectBlock) (HSBusinessInfoBasicView* view);

@interface HSBusinessInfoBasicView : KSView

@property (nonatomic, strong) HSDeviceInfoModel              *bussinessDetailModel;

@property (nonatomic, strong) HSDeviceModel                  *deviceModel;

@property (nonatomic, strong) NSNumber                       *productId;

@property (nonatomic, strong) NSNumber                       *deviceId;

@property (nonatomic, strong) UIView                         *topline;

@property (nonatomic, strong) UIView                         *middelline;

@property (nonatomic, strong) UIView                         *endline;

@property (nonatomic ,copy)   businessViewDidSelectBlock      businessViewDidSelectBlock;

- (void)reloadData;

@end
