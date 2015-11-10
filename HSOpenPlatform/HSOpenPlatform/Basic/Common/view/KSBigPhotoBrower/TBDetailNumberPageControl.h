//
//  TBDetailNumberPageControl.h
//  TBTradeDetail
//
//  Created by chen shuting on 14/12/19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBDetailNumberPageControl : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL      hidesForSinglePage;

@end
