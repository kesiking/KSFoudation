//
//  WeAppDebugBasicTextView.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-4.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugBasicView.h"
#import "KSDebugOperationView.h"

@interface KSDebugBasicTextView : KSDebugBasicView

@property(nonatomic, strong)    UITextView*      debugTextView;

-(NSString*)generateStringWithDictionary:(NSDictionary*)dict;

-(NSString*)generateStringWithArray:(NSArray*)array;

-(void)generateStringToDebugTextViewWithDictionary:(NSDictionary*)dict;

-(void)setTitleInfoText:(NSString*)titleInfoText;

@end
