//
//  HSAfterSaleModel.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/24.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSAfterSaleModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString *afterSaleId;        //!< 售后Id
@property (nonatomic, strong) NSString *outletsName;        //!< 网点名称
@property (nonatomic, strong) NSString *outletsType;        //!< 网点类型
@property (nonatomic, strong) NSString *outletsAddress;     //!< 网点地址
@property (nonatomic, strong) NSString *outletsTel;         //!< 网点电话
@property (nonatomic, strong) NSString *outletsMail;        //!< 网点邮箱
@property (nonatomic, strong) NSString *longitude;          //!< 经度
@property (nonatomic, strong) NSString *latitude;           //!< 纬度
@property (nonatomic, strong) NSString *businessLicense;    //!< 营业执照
@property (nonatomic, strong) NSNumber *status;             //!< 状态
@property (nonatomic, strong) NSString *createDate;         //!< 创建时间
@property (nonatomic, strong) NSString *updateDate;         //!< 更新时间

@property (nonatomic, strong) NSString *productIconUrl;         //!< 图标url
@property (nonatomic, strong) NSString *placeholderImageStr;//!< 图标占位图
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;//!< 请求到数据时的当前坐标

@end
