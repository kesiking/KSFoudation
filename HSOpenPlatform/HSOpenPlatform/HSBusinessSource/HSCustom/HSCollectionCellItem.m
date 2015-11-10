//
//  HSCollectionCellItem.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCollectionCellItem.h"

@implementation HSCollectionCellItem

- (instancetype)initWithAppModel:(HSApplicationModel *) appModel{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:appModel.appIconUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            self.itemImage = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.imgView.image = img;
//            });
        }
        self.itemTag  = [appModel.appId integerValue];
        self.itemName = appModel.appName;
    }
    return self;
    
}


@end
