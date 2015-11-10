//
//  EHAleatView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAleatView.h"

@implementation EHAleatView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message clickedButtonAtIndexBlock:(clickedButtonAtIndexBlock)clickedButtonAtIndex cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.delegate = self;
        self.clickedButtonAtIndex = clickedButtonAtIndex;
        [self config];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        [self config];
    }
    return self;
}

- (void)config{
    [self configAleatCustonView];
}

- (void)configAleatCustonView{
    UIView* subview = [self getAleatCustomView];
    if (subview) {
        //check if os version is 7 or above
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.message = nil;
            [self setValue:subview forKey:@"accessoryView"];
        }else{
            [self addSubview:subview];
        }
    }
}

- (UIView*)getAleatCustomView{
    return self.customView;
}

-(void)setCustomView:(UIView *)customView{
    _customView = customView;
    [self configAleatCustonView];
}

-(void)dealloc{
    self.delegate = nil;
    self.clickedButtonAtIndex = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.clickedButtonAtIndex) {
        self.clickedButtonAtIndex((EHAleatView*)alertView, buttonIndex);
    }
}

@end
