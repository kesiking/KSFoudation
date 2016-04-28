//
//  HSProductInfoModel.h
//  HSOpenPlatform
//
//  Created by xtq on 16/2/22.
//  Copyright © 2016年 孟希羲. All rights reserved.
//  产品介绍model

#import "WeAppComponentBaseItem.h"

@protocol HSProductComboModel <NSObject>
@end

@interface HSProductComboModel : WeAppComponentBaseItem

//@property (nonatomic, strong) NSString *productMenuName;
//@property (nonatomic, strong) NSString *productMenuIntroduction;

@property (nonatomic, strong) NSString *comboType;      //!< 套餐类型
@property (nonatomic, strong) NSString *comboContent;   //!< 套餐内容

@end



@interface HSProductInfoModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSNumber *productId;          //!< 产品ID
@property (nonatomic, strong) NSString *productName;        //!< 产品名称
@property (nonatomic, strong) NSString *productInfo;        //!< 产品简介
@property (nonatomic, strong) NSNumber *partnerId;          //!< 合作伙伴
@property (nonatomic, strong) NSNumber *businessId;         //!< 业务类型
@property (nonatomic, strong) NSString *productPrice;       //!< 产品价格
@property (nonatomic, strong) NSArray<HSProductComboModel>  *combos;  //!< 套餐
@property (nonatomic, strong) NSString *productLogo;        //!< 产品LOGO
@property (nonatomic, strong) NSString *productExplain;     //!< 产品说明
@property (nonatomic, strong) NSString *productImage;       //!< 产品首页图片
@property (nonatomic, strong) NSArray  *productImages;      //!< 产品图片数组
@property (nonatomic, strong) NSString *platUrl;            //!< 电商平台
@property (nonatomic, strong) NSNumber *isIndex;            //!< 是否首页
@property (nonatomic, strong) NSNumber *status;             //!< 状态
@property (nonatomic, strong) NSString *createDate;         //!< 创建时间
@property (nonatomic, strong) NSString *updateDate;         //!< 更新时间

@property (nonatomic, strong) NSString *placeholderImageStr;//!< 占位图

//@property (nonatomic, strong) NSString *productName;
//@property (nonatomic, strong) NSString *productTitle;
//@property (nonatomic, strong) NSString *productIconUrl;
//@property (nonatomic, strong) NSString *productPrice;
//@property (nonatomic, strong) NSString *productIntroduction;
//@property (nonatomic, strong) NSString *productInstruction;
//@property (nonatomic, strong) NSArray  *productImages;
//@property (nonatomic, strong) NSArray<HSProductComboModel>  *productMenus;

@end

