//
//  HSCollectionCellItem.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSApplicationModel.h"

@interface HSCollectionCellItem : NSObject

@property (strong, nonatomic) NSString *itemName;
//@property (strong, nonatomic) NSString *itemImageName;
@property (strong, nonatomic) UIImage *itemImage;
@property (assign, nonatomic) NSInteger itemTag;
//@property (strong, nonatomic) NSString *appIntroH5Link;

- (instancetype)initWithAppModel:(HSApplicationModel *) appModel;


@end
