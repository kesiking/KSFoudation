//
//  WeAppDebugInfoBasicView.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSServiceDebug_PlotsView.h"
#import "KSDebugMemoryModel.h"
#import "KSDebugMaroc.h"

@interface KSDebugInfoBasicView : UIView<KSDebugMemoryModelProtocol>

@property (nonatomic, strong) KSServiceDebug_PlotsView   *plotsView;

-(void)load;

-(void)unload;

-(void)setLableInfo:(NSString*)info;

-(void)setLableTitle:(NSString*)title;

@end
