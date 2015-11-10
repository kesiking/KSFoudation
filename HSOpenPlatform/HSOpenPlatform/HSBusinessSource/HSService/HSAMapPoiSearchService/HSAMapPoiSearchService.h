//
//  HSAMapPoiSearchService.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSMapPoiModel.h"

typedef void(^SearchFinishedBlock)(NSArray *);
typedef void(^SearchFailedBlock)(void);

@interface HSAMapPoiSearchService : NSObject

@property (nonatomic, copy)SearchFinishedBlock searchFinishedBlock;

@property (nonatomic, copy)SearchFailedBlock   searchFailedBlock;

@property (nonatomic, assign) NSInteger offset;

- (void)searchPoiWithPageNumber:(NSInteger)pageNumber;

@end
