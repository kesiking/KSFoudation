//
//  TBURLAction.h
//  Taobao4iPad
//
//  Created by Tim Cao on 12-4-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "TBNavigationType.h"
#import "TBNavigationParams.h"
#import "TBNavigatorURLParams.h"

@interface TBURLAction : NSObject {
    NSURL*                          _URL;
}

@property (nonatomic, strong)   NSString*                 urlPath;
@property (nonatomic, strong)   UIViewController*         sourceController;
@property (nonatomic, strong)   UIViewController*         targetController;
@property (nonatomic, strong)   NSDictionary*             nativeParams;
@property (nonatomic, strong)   NSDictionary*             extraInfo;
@property (nonatomic, readonly) NSURL*                    URL;

+ (id)actionWithURLPath:(NSString*)urlPath sourceController:(UIViewController*)sourceViewController;

- (id)initWithURLPath:(NSString*)urlPath sourceController:(UIViewController*)sourceViewController;

// 辅助功能函数

// 判断URL是否合法，即包含schem 包含host 包含path
- (BOOL)isActionURLLegal;

// 获取URL的path，去掉开头的"/"
- (NSString*)getURLPathWithoutSlash;

// 预留数据
@property (nonatomic, strong) TBNavigationParams*       navigationParams;
@property (nonatomic, strong) NSDictionary*             objcProperties;

@end

NSStringEncoding TBDefaultEncoding();
