//
//  HSAppDetailPicModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@protocol HSAppDetailPicModel <NSObject>

@end

@interface HSAppDetailPicModel : WeAppComponentBaseItem

@property (strong,nonatomic) NSString *appImage;

@end
