//
//  HSCollectionItem.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCollectionItem : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemImageName;
@property (assign, nonatomic) NSInteger itemTag;

@end
