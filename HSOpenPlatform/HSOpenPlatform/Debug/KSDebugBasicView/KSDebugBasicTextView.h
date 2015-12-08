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

@property(nonatomic, strong)    UILabel *        infoLabel;

@property(nonatomic, assign)    CGRect           debugTextViewFrame;

-(NSString*)generateStringWithDictionary:(NSDictionary*)dict;

-(NSString*)generateStringWithArray:(NSArray*)array;

-(void)saveArrayToKSDebugDiskWithArray:(NSArray*)array keyPath:(NSString*)path;

-(void)saveDictionaryToKSDebugDiskWithDictionary:(NSDictionary*)dictionary keyPath:(NSString*)path;

-(void)generateStringToDebugTextViewWithDictionary:(NSDictionary*)dict;

-(void)setTitleInfoText:(NSString*)titleInfoText;

-(void)keyboardDidShowWithTextView:(UITextView*)debugTextView;

-(void)keyboardDidHideWithTextView:(UITextView*)debugTextView;

@end
