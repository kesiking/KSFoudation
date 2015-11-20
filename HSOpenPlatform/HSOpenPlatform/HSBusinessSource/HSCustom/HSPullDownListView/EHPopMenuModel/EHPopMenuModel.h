//
//  EHPopMenuModel.h
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@protocol EHPopMenuModel <NSObject>

@end

@interface EHPopMenuModel : WeAppComponentBaseItem

- (instancetype)initWithTitleText:(NSString*)titleText;

@property (nonatomic, strong)   NSString*           titleText;

@property (nonatomic, strong)   NSString*           iconImageUrl;

@property (nonatomic, strong)   UIImage*            iconImage;

@property (nonatomic, strong)   id                  menuExtModel;

@end
