//
//  TBPageControl.h
//  TBWeApp
//
//  Created by 逸行 on 14-3-21.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol WeAppPageControlProtocol <NSObject>

-(void)setPageControlNumberOfPages:(NSUInteger)numberOfPages;

-(NSUInteger)getPageControlNumberOfPages;

-(void)setPageControlCurrentPage:(NSUInteger)currentPage;

-(NSUInteger)getPageControlCurrentPage;

-(void)setPageControlPreDisplayedPage:(NSUInteger)preDisplayedPage;

-(NSUInteger)getPageControlPreDisplayedPage;

@end

@interface TBPageControl : UIPageControl

@property (nonatomic,assign) NSInteger preDisplayedPage;

@end
